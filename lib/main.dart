import 'package:flutter/material.dart';
import 'package:infinite_scroll_list_example/injections.dart';
import 'package:infinite_scroll_list_example/pages/home_using_visibility_detector.dart';

void main() {
  configureInjection();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Home(),
    );
  }
}
