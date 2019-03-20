import 'package:buhaychat/Pages/UsersChatPage.dart';
import 'package:buhaychat/Pages/RegisterPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseAuth.currentUser().then((value) async {
      FirebaseUser firebaseUser = value;
      if (firebaseUser != null) {

        _firebaseMessaging.requestNotificationPermissions();
        _firebaseMessaging.configure();

        DocumentReference ref = Firestore.instance.collection('users')
            .document(firebaseUser.uid);

        _firebaseMessaging.getToken().then((onValue) async{
          print("deviceToken: " + onValue);
          ref.updateData({
            'deviceToken': onValue,
          });
        }
        );


        //Uses an asynctask to retrieve the firebaseUser
          // Checks if the users email is in our database
          final QuerySnapshot result =
              await Firestore.instance.collection('users').where(
              'id', isEqualTo: firebaseUser.uid).getDocuments();
          final List<DocumentSnapshot> documents = result.documents;


          // If email was not found, create new user

          if (documents.length == 0 || documents == null) {
            print("email was not found, create new user");

            DocumentReference ref = Firestore.instance.collection('users')
                .document(firebaseUser.uid);
            ref.setData(
                {
                  'nickname': firebaseUser.displayName,
                  'photoUrl': firebaseUser.photoUrl,
                  'id': firebaseUser.uid,
                  'email': firebaseUser.email
                });
          }



        // Open Friends Page passing in the user's info
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UsersChatPage(UID: firebaseUser.uid, userEmail: firebaseUser.email, userName: firebaseUser.displayName, userPhoto: firebaseUser.photoUrl),
            ));
      } else {

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterPage(),
              ));

      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(body:Center(child: CircularProgressIndicator(),));
  }

}
