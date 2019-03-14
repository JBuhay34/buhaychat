import 'package:buhaychat/Pages/AddContactPage.dart';
import 'package:buhaychat/Pages/UsersChatPage.dart';
import 'package:buhaychat/Pages/MessageRoomPage.dart';
import 'package:buhaychat/Pages/RegisterPage.dart';
import 'package:buhaychat/Pages/SplashPage.dart';
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
      home: SplashPage(),//MainAppPage()

    );
  }
}

