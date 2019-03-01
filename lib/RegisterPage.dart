import 'package:buhaychat/MainAppPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  static String googleloginButtonPath = "images/btn_google_signin.png";

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      'https://www.googleapis.com/auth/userinfo.profile'
    ],
  );

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser firebaseUser = await firebaseAuth.signInWithCredential(credential);
    print("signed in " + firebaseUser.displayName);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainAppPage(UID: firebaseUser.uid,email: firebaseUser.email, userName: firebaseUser.displayName)),
    );
    return firebaseUser;
  }

  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();


    firebaseAuth.currentUser().then((value) async {
      firebaseUser = value;

      print("Name is "+ firebaseUser.displayName);

      if (firebaseUser != null) {
        // Check if already signed up
        final QuerySnapshot result =
        await Firestore.instance.collection('users').where(
            'email', isEqualTo: firebaseUser.email).getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        if (documents.length == 0) {
          // Update data to server if new user
          DocumentReference ref =Firestore.instance.collection('users')
              .document(firebaseUser.email);
          ref.setData(
              {
                'nickname': firebaseUser.displayName,
                'photoUrl': firebaseUser.photoUrl,
                'id': firebaseUser.uid,
                'email': firebaseUser.email
              });



        } else{

        }



      }

    });

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(title: Text("Register"),automaticallyImplyLeading: false),
        body: Center(
            child: Column(children: [
          GestureDetector(
            onTap: () {
              _handleSignIn()
                  .then((FirebaseUser user) => print(user))
                  .catchError((e) => print(e));

            },
            child: Image(
                image: AssetImage(googleloginButtonPath),
                height: 50.0,
                width: 330.0),
          ),
          Text("Hello World")
        ])));
    ;
  }
}
