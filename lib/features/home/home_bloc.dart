import 'dart:async';
import 'dart:io';
import 'package:audio_to_text/model/api_error_response.dart';
import 'package:audio_to_text/services/home_service.dart';
import 'package:audio_to_text/utils/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeBloc {
  // region Common Variables
  BuildContext context;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String filePath = "";
  late Timer progressTimer;
  double progress = 1;

  // endregion

  // region Services
  HomeService homeService = HomeService();

  // endregion

  // region Controller
  final recordingCtrl = StreamController<double>.broadcast();
  final permissionCtrl = StreamController<bool>.broadcast();
  final loadingCtrl = StreamController<bool>.broadcast();
  final transcribeCtrl = StreamController<String>.broadcast();

  // endregion

  // region | Constructor |
  HomeBloc(this.context);

  // endregion

  // region Init
  void init() {
    _initializeRecorder();
    _initialisePermission();
  }

// endregion

  // region _initialisePermission
  Future<void> _initialisePermission() async {
    PermissionStatus storagePermission = await Permission.storage.request();
    PermissionStatus microphonePermission = await Permission.microphone.request();

    var isGranted = storagePermission.isGranted && microphonePermission.isGranted;
    if (!permissionCtrl.isClosed) permissionCtrl.sink.add(isGranted);
  }

  // endregion

  // region _initializeRecorder
  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
  }

  // endregion

  // region startRecording
  Future<void> startRecording() async {
    progress = 0;
    if (!recordingCtrl.isClosed) recordingCtrl.sink.add(progress);
    if (!transcribeCtrl.isClosed) transcribeCtrl.sink.add("");
    final tempDir = await getTemporaryDirectory();
    filePath = '${tempDir.path}/audio_temp.wav';

    // checkAndRemoveFile
    final file = File(filePath);
    if (await file.exists()) await file.delete();

    // startRecorder
    await _recorder.startRecorder(toFile: filePath, codec: Codec.pcm16WAV);

    // update progress
    progressTimer = Timer.periodic(const Duration(milliseconds: 1), (Timer t) {
      progress = progress + 1;
      if (progress >= 10000) {
        progressTimer.cancel();
        stopRecording(); // after complete timer
      }
      if (!recordingCtrl.isClosed) recordingCtrl.sink.add(progress / 10000);
    });
  }

  // endregion

  // region stopRecording
  Future<void> stopRecording() async {
    try {
      // stop recorder
      progressTimer.cancel();
      if (!recordingCtrl.isClosed) recordingCtrl.sink.add(0);
      await _recorder.stopRecorder();

      // call open AI api
      if (!loadingCtrl.isClosed) loadingCtrl.sink.add(true);
      var response = await homeService.getTranscribe(filePath);

      // get response
      var transcribe = response.text!;
      if (!transcribeCtrl.isClosed) transcribeCtrl.sink.add(transcribe);
    } on ApiErrorResponse catch (error) {
      print(error.error!.message);
    } catch (exception) {
      print(exception.toString());
    } finally {
      if (!loadingCtrl.isClosed) loadingCtrl.sink.add(false);
      if (!recordingCtrl.isClosed) recordingCtrl.sink.add(0);

    }
  }

  // endregion

// region dispose
  void dispose() {
    recordingCtrl.close();
    if (progressTimer.isActive) {
      progressTimer.cancel();
    }
  }
// endregion
}
