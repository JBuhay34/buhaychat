import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddContactPage extends StatefulWidget {
  String UID;

  AddContactPage({Key key, String UID}) : super(key: key) {
    this.UID = UID;
  }

  @override
  _AddContactPageState createState() => _AddContactPageState(UID);
}

class _AddContactPageState extends State<AddContactPage> {
  String UID;
  final myController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  _AddContactPageState(String UID) {
    this.UID = UID;
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
        appBar: AppBar(title: Text("Add Friend")),
        body: Column(children: [
          (Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextFormField(
                controller: myController,
                decoration: InputDecoration(
                    labelText: 'Enter the email you would like to add'),
              ))),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              //Add and check if contact exists in firebase. And check if they're not already a contact
              addContact(myController.text);
            },
          )
        ]));
  }

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
          if (documents.length != 0) {
            // Update data to server if new user
            String chatRoomID = "";
            List<String> array = List<String>();
            array.add(emailEntered);
            array.add(firebaseUser.email);
            array.sort();
            for(String i in array){
              chatRoomID += i;
            }
            print("chatRoomID"+chatRoomID);
            String id;
            String nickname;
            for (DocumentSnapshot snapshot in documents) {
              nickname = snapshot['name'];
              id = snapshot['id'];
              nickname = snapshot['nickname'];
            }

            Firestore.instance
                .collection('userContacts')
                .document(UID).setData({'nickname': firebaseUser.displayName});

            DocumentReference ref = Firestore.instance
                .collection('userContacts')
                .document(UID)
                .collection("contacts")
                .document(emailEntered);
            ref.setData({
              'nickname': nickname,
              'id': id,
              'email': emailEntered,
              'message': "",
              'date': "",
              'sender': "",
              'chat': chatRoomID,
            });

            DocumentReference ref2 = Firestore.instance
                .collection('userContacts')
                .document(id)
                .collection("contacts")
                .document(firebaseUser.email);
            ref2.setData({
              'nickname': firebaseUser.displayName,
              'id': firebaseUser.uid,
              'email': firebaseUser.email,
              'message': "",
              'date': "",
              'sender': "",
              'chat': chatRoomID,
            });
            
            DocumentReference ref3 = Firestore.instance.collection("chats").document(chatRoomID);
            ref3.setData({
              "numOfMembers": array.length,
              "name": "Whats up"
            });

          } else{
            AlertDialog(
              // Retrieve the text the user has typed in using our
              // TextEditingController
              content: Text("There is no user with that name"),
            );
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
