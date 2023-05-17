import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spotify_africa_assessment/routes.dart';

late Store<int> store;

void main() {
  store = Store<int>(initialState: 0);
  runApp(const PalotaAssessmentApp());
}

class PalotaAssessmentApp extends StatelessWidget {
  const PalotaAssessmentApp({Key? key}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palota Spotify Africa Assessment',
      theme: ThemeData.dark(useMaterial3: true),
      initialRoute: AppRoutes.startUp,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
