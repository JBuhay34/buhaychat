import 'dart:collection';

import 'package:buhaychat/Pages/MessageRoomPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateChatRoomPage extends StatefulWidget {
  String UID;
  String userEmail;
  String userName;
  String userPhotoUrl;
  CreateChatRoomPage({Key key, String UID, String userEmail, String userName, String userPhotoUrl}) : super(key: key){

    this.UID = UID;
    this.userEmail = userEmail;
    this.userName = userName;
    this.userPhotoUrl = userPhotoUrl;
  }

  @override
  _CreateChatRoomPageState createState() => _CreateChatRoomPageState(UID, userEmail, userName, userPhotoUrl);
}

class _CreateChatRoomPageState extends State<CreateChatRoomPage> {

  List<String> membersForGroupChat = List<String>();
  // Key: memberID, Value: memberName, memberPhotoUrl
  //HashMap<String, List<String>> memberHashMap = HashMap<String, List<String>>();

  String UID;
  String userEmail;
  String userName;
  String userPhotoUrl;
  String chatName = "";

  final myController = TextEditingController();


  _CreateChatRoomPageState(String UID, String email, String userName, String userPhotoUrl){
    this.UID = UID;
    this.userEmail = email;
    this.userPhotoUrl = userPhotoUrl;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          children: [
            TextFormField(
                  controller: myController,
                  decoration: InputDecoration(
                      labelText: 'Chat Room Name'),
                )

            ,
            Expanded(child:StreamBuilder(
                stream:
                Firestore.instance.collection('userContacts')
                    .document(UID)
                    .collection("contacts")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading...");
                  } else {
                    return ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int position) {
                          return _getRow(snapshot.data.documents[position]);
                        });
                  }
                }
            )
            ),
          ]
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: const Icon(Icons.create),
        label: const Text('Chat'),
        onPressed: () {

          if(myController.text.isNotEmpty && membersForGroupChat.length != 0){
            createGroupChat(myController.text);
          } else{
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Need a Chat Name and Members"),
                  );
                }
            );
          }

        }
,
      ),
    );
  }

  // ListView for showing the users contacts
  Widget _getRow(DocumentSnapshot document) {
    String friendName = document['nickname'];
    String friendID = document['id'];
    String friendEmail = document['email'];
    String friendPhotoUrl = document['photoUrl'];

    BoxDecoration boxDecor = BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Colors.lightBlue.shade50)
        ),
        color: (membersForGroupChat.contains(friendID)) ? Colors.grey : Colors
            .transparent
    );

    return GestureDetector(
      child: Container(
        decoration: boxDecor,
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
                              (friendName == null) ? " " : friendName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                  fontSize: 17.0),
                            ),
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
                                  (friendEmail == null || friendEmail == "")
                                      ? ""
                                      : friendEmail,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 15.5),
                                ),
                              ],
                            ),
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
        //TODO: When a contact is clicked we want to add them to the groupchat, if clicked again and is in list, remove
        if (membersForGroupChat.contains(friendID)) {
          membersForGroupChat.remove(friendID);
          //memberHashMap.remove(friendID);
          setState(() {});
        } else {

//          List<String> friendNamePhotoUrl = new List<String>();
//          friendNamePhotoUrl.add(friendName);
//          friendNamePhotoUrl.add(friendPhotoUrl);

          membersForGroupChat.add(friendID);
          //memberHashMap.putIfAbsent(friendID, membersForGroupChat);

          setState(() {});
        }
        for (String mem in membersForGroupChat) {
          print("members: " + mem);
        }
      }
      , behavior: HitTestBehavior.opaque,
    );
  } // getRow()

  createGroupChat(String chatName){


    this.chatName = chatName;
    print("chatName" + chatName);

    //TODO: create the groupchat
    DocumentReference ref = Firestore.instance
        .collection("chats")
        .document();

    //TODO: want to add the photoURL of every mems UID


    String refDocID = ref.documentID;

    ref.setData({
      'chatID': refDocID,
      'chatName': chatName,
    });

    // Add yourself to the groupchat
    ref.collection("members").document(UID).setData({
      "id": UID
    });

    Firestore.instance
        .collection("usersChats")
        .document(UID).collection("chats").document(refDocID).setData({
      "numMembersInChat": membersForGroupChat.length,
      'chatID': refDocID,
      'chatName': chatName
    });

    // we add to the usersChats/chats for each member
    for (String mem in membersForGroupChat) {

      ref.collection("members").document(mem).setData({
        "id": mem
      });

      Firestore.instance
          .collection("usersChats")
          .document(mem).collection("chats").document(refDocID).setData({
        "numMembersInChat": membersForGroupChat.length,
        'chatID': refDocID,
        'chatName': chatName
      });

    }

    Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MessageRoomPage( userEmail: userEmail, userName: userName, UID: UID, chatName: chatName, chatRoomID: refDocID, userPhotoUrl: userPhotoUrl,)),
          );
  }

@override
  void dispose() {
  if (myController != null) myController.dispose();
    super.dispose();
  }
}