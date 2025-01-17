import 'package:audio_to_text/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';
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

      ],
    );
  }

// endregion

}
