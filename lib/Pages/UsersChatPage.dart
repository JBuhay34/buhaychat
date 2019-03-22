import 'package:buhaychat/AppColors.dart';
import 'package:buhaychat/Pages/AddContactPage.dart';
import 'package:buhaychat/Pages/CreateChatRoomPage.dart';
import 'package:buhaychat/Pages/MessageRoomPage.dart';
import 'package:buhaychat/Pages/RegisterPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<RegisterPage> _handleSignOut() async {
    FirebaseAuth.instance.signOut().then((onValue) async{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>RegisterPage()));

      return RegisterPage();
    });
  }

// Drawer
  Drawer drawer;


  FirebaseUser firebaseUser;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    drawer = new Drawer(
        child: Container(
            color: AppColors.primaryColor,
            padding: EdgeInsets.fromLTRB(50, 100, 0, 0),
            child: ListView(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        _handleSignOut();
                      },
                      child:Text("Sign out",
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Roboto', color: AppColors.textColor),
                      ),
                    )
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Import Contacts",
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Roboto', color: AppColors.textColor),
                  ),
                )

              ],
            )
        )
    );


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
  var text = Text("Messages", style: TextStyle(color: AppColors.textColor),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
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
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        color: AppColors.backgroundColor
        , child: StreamBuilder(
          stream:
          Firestore.instance.collection('usersChats').document(UID).collection("chats").orderBy("date", descending: true).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Text(
                "Loading...", style: TextStyle(color: AppColors.textColor),);
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
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        backgroundColor: AppColors.accentColor,
        onPressed: (){
          //TODO: create a chatroompage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateChatRoomPage(UID: UID, userEmail: userEmail, userName: userName, userPhotoUrl: userPhoto)),
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
    String chatName = document['chatName'];
    String message = document['message'];
    if(message != null){
      if(message.length > 20){
        message = message.substring(0,20);
      }
    }
    // Check if the message is from today, just show the time
    DateTime now = DateTime.now();
    if (dateMessage != null || dateMessage == 1) {
      DateTime checks = DateTime.fromMillisecondsSinceEpoch(dateMessage);

      if(checks.day == now.day){
        dateString = new DateFormat.jm().format(
            checks
        );
      } else{
        dateString = new DateFormat.yMd().add_jm().format(
            checks
        );
      }
    }

    String photoUrl = document['photoUrl'];


    Expanded childWidget = Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: Text(
                      (chatName == null) ? " ": chatName,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                          fontSize: 17.0),
                    )
                ),
                Container(
                    constraints: BoxConstraints(maxWidth: 100),
                    child:Text(
                      (dateMessage == null || dateMessage == 1)
                          ? " "
                          : dateString,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                          fontSize: 13.5
                      ),
                    ))
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
                      (message == null || message == "") ? "No messages yet" : message,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
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
    );


    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.lightBlue.shade50)
            )
        ),
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: 14.0, right: 14.0, top: 5.0, bottom: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                (photoUrl == null) ? Icon(
                  Icons.account_circle,
                  size: 55.0,
                  color: Colors.blue,
                ) : Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                      image: DecorationImage(
                          image: new NetworkImage(
                              photoUrl
                          ),
                          fit: BoxFit.fill
                      )
                  ),
                ),
                childWidget
              ],
            ),
          ),
        ]
        ),
      ),
      onTap: () {
        //TODO: edit MessageRoomPage

        chatNameClicked = document['chatName'];
        chatRoomID = document['chatID'];
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              MessageRoomPage(
                  userEmail: userEmail,
                  userName: userName,
                  UID: UID,
                  chatName: chatNameClicked,
                  chatRoomID: chatRoomID,
                  userPhotoUrl: userPhoto)),
        );

        setState(() {
          // setState, when you want to refresh the ListView(notifyDataSetChanged)
        }
        );
      },

      onLongPress: () {
        chatNameClicked = document['chatName'];
        chatRoomID = document['chatID'];
        deleteChat(chatRoomID, chatNameClicked);
        setState(() {
          // setState, when you want to refresh the ListView(notifyDataSetChanged)
        }
        );
      },
    );
  } // getRow()


  void deleteChat(String chatRoomID, chatRoomName) async{
    await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete Chat?"),
            content: Text(chatRoomName),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  // Removes from the usersChats
                  Firestore.instance.collection("usersChats").document(
                      UID).collection("chats").document(chatRoomID).delete().then((void hm) {
                    // need only once
                    Navigator.of(context).pop();
                  });

                  // Removes from the members of the chat
                  Firestore.instance.collection("chats").document(
                      chatRoomID).collection("members").document(UID)
                      .delete()
                      .then((void hm) {});
                },

              )
            ],
          );
        }
    );
  }


} // _MainPageState


