import 'package:buhaychat/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MembersOfChatPage extends StatefulWidget {
  String UID;
  String userEmail;
  String userName;
  String userPhotoUrl;
  String chatRoomID;
  String chatName;

  MembersOfChatPage(
      {Key key,
      String UID,
      String userEmail,
      String userName,
      String userPhotoUrl,
      String chatRoomID,
      String chatName})
      : super(key: key) {
    this.UID = UID;
    this.userEmail = userEmail;
    this.userName = userName;
    this.userPhotoUrl = userPhotoUrl;
    this.chatRoomID = chatRoomID;
    this.chatName = chatName;
  }

  @override
  _MembersOfChatPageState createState() => _MembersOfChatPageState(
      UID, userEmail, userName, userPhotoUrl, chatRoomID, chatName);
}

class _MembersOfChatPageState extends State<MembersOfChatPage> {
  String userPhotoUrl = "";
  String UID;
  String userEmail;
  String chatNameClicked;
  String userName;
  String friendEmail;
  String chatRoomID;
  String chatName;

  _MembersOfChatPageState(String UID, String userEmail, String userName,
      String userPhotoUrl, String chatRoomID, String chatName) {
    this.UID = UID;
    this.userEmail = userEmail;
    this.userName = userName;
    this.userPhotoUrl = userPhotoUrl;
    this.chatRoomID = chatRoomID;
    this.chatName = chatName;
  }

  @override
  Widget build(BuildContext context) {
    Scaffold scaffold = Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(chatName),
        ),
        body: Container(
          color: AppColors.backgroundColor,
          child: Column(children: <Widget>[
            StreamBuilder(
                stream: Firestore.instance
                    .collection('chats')
                    .document(chatRoomID)
                    .collection("members")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading...");
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int position) {
                          return _buildMembersChatList(
                              snapshot.data.documents[position]);
                        },
                      ),
                    );

                    //return Expanded(child: Container(child: Text("No messages")));
                  }
                }),
          ]),
        ));

    return scaffold;
  }

  Widget _buildMembersChatList(DocumentSnapshot document) {
    Row mainChild = Row(
      children: <Widget>[
        Text(document["nickname"], style: TextStyle(color: AppColors.textColor,
            fontFamily: 'Roboto'),),
      ],
    );

    return GestureDetector(
      child: mainChild,
      onTap: () {

      },
    );
  }
}
