import 'package:buhaychat/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddContactPage extends StatefulWidget {
  String UID;
  String userEmail;

  AddContactPage({Key key, String UID, String userEmail}) : super(key: key) {
    this.UID = UID;
    this.userEmail = userEmail;
  }

  @override
  _AddContactPageState createState() => _AddContactPageState(UID, userEmail);
}

class _AddContactPageState extends State<AddContactPage> {
  String UID;
  String userEmail;

  final myController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Constructor
  _AddContactPageState(String UID, String userEmail) {
    this.UID = UID;
    this.userEmail = userEmail;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (myController != null) myController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Friend"), backgroundColor: AppColors.primaryColor,),
        body: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            color: AppColors.backgroundColor,
            child: Column(children: [
              (Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: TextFormField(
                    controller: myController,
                    decoration: InputDecoration(
                        labelText: 'Enter the email you would like to add'),
                  ))),
            ])

        ),
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        backgroundColor: AppColors.accentColor,
        onPressed: (){
          addContact(myController.text.toLowerCase());
        },
        child: Icon(Icons.person_add),
      ),
    );
  }

  //TODO: Add and check if contact exists in Firebase. And check if they're not already a contact
  addContact(String emailEntered) {
    FirebaseUser firebaseUser;

    if(emailEntered != "" || emailEntered == null){
      firebaseAuth.currentUser().then((value) async {
        firebaseUser = value;

        if (firebaseUser != null) {
          // Check if email is in users folder of firebase
          final QuerySnapshot result = await Firestore.instance
              .collection('users')
              .where('email', isEqualTo: emailEntered)
              .getDocuments();

          final List<DocumentSnapshot> documents = result.documents;

          // if there is a user with that email add to userContacts/$UID/contacts
          if (documents.length == 1) {
            String friendNickname;
            String friendID;
            String friendEmail;
            String friendPhotoURL;

            for (DocumentSnapshot snapshot in documents) {
              friendNickname = snapshot['nickname'];
              friendID = snapshot['id'];
              friendEmail = snapshot['email'];
              friendPhotoURL = snapshot['photoUrl'];
            }

            // create an instance for the userscontacts
            Firestore.instance
                .collection('userContacts')
                .document(UID).setData({'nickname': firebaseUser.displayName});


            // add to current users contacts
            DocumentReference ref = Firestore.instance
                .collection("userContacts")
                .document(UID)
                .collection("contacts")
                .document(friendID);
            ref.setData({
              'nickname': friendNickname,
              'id': friendID,
              'email': friendEmail,
              'photoUrl': friendPhotoURL
            });


            // Add to the other users contacts
            DocumentReference ref2 = Firestore.instance
                .collection("userContacts")
                .document(friendID)
                .collection("contacts")
                .document(UID);
            ref2.setData({
              'nickname': firebaseUser.displayName,
              'id': firebaseUser.uid,
              'email': firebaseUser.email,
              'photoUrl': firebaseUser.photoUrl
            });

//            DocumentReference ref3 = Firestore.instance.collection("chats").document();
//            ref3.updateData({
//              "numOfMembers": array.length,
//              "name": "Whats up"
//            });

            showDialog(
                context: context,
                builder:(BuildContext context){
                  return AlertDialog(
                    // Retrieve the text the user has typed in using our
                    // TextEditingController
                    title: Text(myController.value.text + " added"),
                  );
                }
            );
          } else{
            showDialog(
                context: context,
                builder:(BuildContext context){
                  return AlertDialog(
                    // Retrieve the text the user has typed in using our
                    // TextEditingController
                    title: Text("There is no user with that name"),
                  );
                }
            );

            print("No user");
          }

//
//        Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context) => MainAppPage(UID: firebaseUser.uid,)),
//        );
        }
      });
    }
  }
}
