import 'package:audio_to_text/features/home/home_screen.dart';
import 'package:flutter/material.dart';

// region App
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // region Build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {'/home': (context) => const HomeScreen()},
      initialRoute: '/home',
    );
  }
  // endregion

}
// endregion
