import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'utils/app_constants.dart';

void main() {
// load env file
  dotenv.load(fileName: ".env").then((value) {
    // get config
    AppConstants.apiKey = dotenv.env[AppConstants.openAIKey]!;

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
      runApp(const App());
    });
  });
}
