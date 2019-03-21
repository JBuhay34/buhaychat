import 'package:buhaychat/Pages/UsersChatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:buhaychat/AppColors.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

// Register the user
class RegisterPageState extends State<RegisterPage> {
  static String googleloginButtonPath = "images/btn_google_signin.png";

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
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

   firebaseUser = await firebaseAuth.signInWithCredential(credential);
    if(firebaseUser == null){
      print("firebase user is null");
    }
    if (firebaseUser != null) {
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
    }
    print("signed in " + firebaseUser.displayName);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UsersChatPage(UID: firebaseUser.uid, userEmail: firebaseUser.email, userName: firebaseUser.displayName)),
    );
    return firebaseUser;
  }

  final GoogleSignIn googleSignIn = new GoogleSignIn();
  FirebaseAuth firebaseAuth;

  FirebaseUser firebaseUser;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    firebaseAuth = FirebaseAuth.instance;

     //Uses an asynctask to retrieve the firebaseUser
//    firebaseAuth.currentUser().then((value) async {
//      firebaseUser = value;
//      createNewUser(firebaseUser);
//    });

  }




  @override
  Widget build(BuildContext context) {

    // button to login with google
    GestureDetector loginWithGoogleButton = GestureDetector(
      onTap: () {
        _handleSignIn()
            .then((FirebaseUser user) => print(user))
            .catchError((e) => print(e));

      },
      child: Image(
          image: AssetImage(googleloginButtonPath),
          height: 50.0,
          width: 330.0),
    );


    return Scaffold(
        appBar: AppBar(title: Text("Register",),automaticallyImplyLeading: false, backgroundColor: AppColors.primaryColor,),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.backgroundColor,
            child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
              loginWithGoogleButton,
            ])
            )
        )
    );
    ;
  }
}
