import 'package:buhaychat/MainAppPage.dart';
import 'package:buhaychat/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseAuth.currentUser().then((value) {
      FirebaseUser firebaseUser = value;
      if (firebaseUser != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainAppPage(UID: firebaseUser.uid, email: firebaseUser.email, userName: firebaseUser.displayName),
            ));
      } else {
        if (firebaseUser != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterPage(),
              ));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
