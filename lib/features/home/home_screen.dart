import 'dart:ui';

import 'package:audio_to_text/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'home_bloc.dart';

// region HomeScreen
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
// endregion

class _HomeScreenState extends State<HomeScreen> {
  // region Bloc
  late HomeBloc homeBloc;

  // endregion

  // region Init
  @override
  void initState() {
    homeBloc = HomeBloc(context);
    homeBloc.init();
    super.initState();
  }

  // endregion

  // endregion build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.appFeature)),
      body: body(),
    );
  }

  // endregion

  // region Body
  Widget body() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                speakBtn(),
                outPutData(),
              ],
            ),
          ),
        ),
        instruction()
      ],
    );
  }

// endregion

// region speakBtn
  Widget speakBtn() {
    return StreamBuilder<double>(
        stream: homeBloc.recordingCtrl.stream,
        initialData: 0,
        builder: (context, snapshot) {
          if (snapshot.data! != 0) return listening(snapshot.data!);
          return StreamBuilder<bool>(
              stream: homeBloc.loadingCtrl.stream,
              initialData: false,
              builder: (context, loading) {
                if (loading.data!) return const CircularProgressIndicator(strokeWidth: 2);
                return GestureDetector(child: const Icon(Icons.spatial_audio_off_outlined, size: 50), onTap: () => homeBloc.startRecording());
              });
        });
  }

// endregion

  // region listening
  Widget listening(double value) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(height: 150, width: 150, child: CircularProgressIndicator(value: value, strokeWidth: 5, backgroundColor: Colors.grey.shade300)),
        CupertinoButton(
            onPressed: () => homeBloc.stopRecording(),
            child: const Text(
              AppStrings.stop,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ))
      ],
    );
  }

  // endregion

// region outPutData
  Widget outPutData() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<String>(
          stream: homeBloc.transcribeCtrl.stream,
          initialData: "",
          builder: (context, snapshot) {
            return Text(
              snapshot.data!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
            );
          }),
    );
  }

// endregion

// region instruction
  Widget instruction() {
    return Container(
      margin: const EdgeInsets.all(30),
      decoration: BoxDecoration(border: Border.all(width: 1), color: Colors.grey.shade50),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline),
            SizedBox(width: 10),
            Expanded(child: Text(AppStrings.instruction)),
          ],
        ),
      ),
    );
  }
// endregion
}
