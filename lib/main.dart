import 'package:buhaychat/MainAppPage.dart';
import 'package:buhaychat/RegisterPage.dart';
import 'package:flutter/material.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Messages",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegisterPage(),//MainAppPage(),
    );
  }
}

