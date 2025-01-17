import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class HomeBloc {
  // region Common Variables
  BuildContext context;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _tempFilePath;
  // endregion

  // region | Constructor |
  HomeBloc(this.context);

  // endregion

  // region Init
  void init() {
    _initializeRecorder();

  }

// endregion

  // region _initializeRecorder
  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
    await _recorder.setAudioSource(AudioSource.microphone);
  }
  // endregion


  Future<void> _startRecording() async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/audio_temp.aac';

    await _recorder.startRecorder(
      toFile: filePath,
      codec: Codec.aacADTS,
    );
    setState(() {
      _isRecording = true;
      _tempFilePath = filePath;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

// region dispose
void dispose(){

}
// endregion

}
