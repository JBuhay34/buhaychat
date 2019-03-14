import 'package:buhaychat/Pages/AddContactPage.dart';
import 'package:buhaychat/Pages/CreateChatRoomPage.dart';
import 'package:buhaychat/Pages/MessageRoomPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:intl/intl.dart";


class UsersChatPage extends StatefulWidget {
  String UID;
  String userEmail;
  String userName;
  String userPhoto;


  UsersChatPage({Key key, String UID, String userEmail, String userName, String userPhoto}) : super(key: key){

    this.UID = UID;
    this.userEmail = userEmail;
    this.userName = userName;
    this.userPhoto = userPhoto;
  }

  @override
  _UsersChatPageState createState() => _UsersChatPageState(UID, userEmail, userName, userPhoto);
}

class _UsersChatPageState extends State<UsersChatPage> {

  String userPhoto = "";
  String UID;
  String userEmail;
  String chatNameClicked;
  String userName;
  String friendEmail;
  String chatRoomID;

  _UsersChatPageState(String UID, String userEmail, String userName, String userPhoto){
    this.UID = UID;
    this.userEmail = userEmail;
    this.userName = userName;
    this.userPhoto = userPhoto;
  }

// Drawer
  Drawer drawer = new Drawer(
      child: new ListView(
        children: <Widget>[
          DrawerHeader(child: Text("BuhayMessage"),
            decoration: BoxDecoration(
                color: Colors.blue
            ),
          ),
          Text("Sign out"),
          Text("Import Contacts")
        ],
      )
  );


  FirebaseUser firebaseUser;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

//  Just in case I need this for reference
//    firebaseAuth
//        .currentUser()
//        .then((value) async {
//      firebaseUser = value;
//
//
//    });

    }

    //Title appbar
    var text = Text("Messages");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: text,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                //Add contact
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddContactPage(UID: UID, userEmail: userEmail)),
                  );
                }
            )
          ]
      ),
      drawer: drawer,
      //TODO: We want this streambuilder to grab the users chats and display them.
      body: StreamBuilder(
          stream:
          Firestore.instance.collection('usersChats').document(UID).collection("chats").snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Text("Loading...");
            } else{
              return

                ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int position) {
                    return _getRow(snapshot.data.documents[position]);
                  });
            }
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          //TODO: create a chatroompage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateChatRoomPage(UID: UID, userEmail: userEmail, userName: userName)),
          );

        },
        child: Icon(Icons.message),
      ),
    );
  }


// ListView for the message content
  Widget _getRow(DocumentSnapshot document) {

    int dateMessage = document['date'];
    String dateString;


    if(dateMessage != null || dateMessage == 1 ){

      dateString = new DateFormat.yMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(dateMessage));
      print("$dateMessage");
    }


    return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color:Colors.lightBlue.shade50)
              )
          ),
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: 14.0, right: 14.0, top: 5.0, bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    size: 55.0,
                    color: Colors.blue,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                (document['nickname'] == null) ? " ": document['nickname'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                    fontSize: 17.0),
                              ),
                              Text(
                                (document['date'] == null||document['date'] == 1) ? " ": dateString,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54,
                                    fontSize: 13.5
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    (document['message'] == null || document['message'] == "") ? "No messages yet" : document['message'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                        fontSize: 15.5),
                                  ),
                                ],
                              ),
                              Icon(Icons.check)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
          ),
        ),
        onTap: () {
          //            //TODO: edit MessageRoomPage

//          chatNameClicked = document['chatName'];
//          chatRoomID = document['chatID'];
//          Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => MessageRoomPage( userEmail: userEmail, userName: userName, UID: UID, chatName: chatNameClicked, chatRoomID: chatRoomID)),
//          );
//
//          setState(() {
//            // setState, when you want to refresh the ListView(notifyDataSetChanged)
//          }
//          );

        }
    );
  } // getRow()
} // _MainPageState

