import 'dart:async';

import 'package:buhaychat/object/MessageWithPerson.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";

class MessageRoomPage extends StatefulWidget {
  String UID;
  String userEmail;
  String chatRoomID;
  String userName;
  String chatName;

  MessageRoomPage(
      {Key key, String UID, String userEmail, String chatRoomID, String userName, String chatName})
      : super(key: key) {
    this.UID = UID;
    this.userEmail = userEmail;
    this.chatRoomID = chatRoomID;
    this.userName = userName;
    this.chatName = chatName;
  }

  _MessageRoomPageState createState() =>
      _MessageRoomPageState(
          UID, userEmail, chatRoomID, userName, chatName);
}

class _MessageRoomPageState extends State<MessageRoomPage> {


  String UID;
  String userEmail;
  String chatRoomID;
  String userName;
  String chatName = "Name";

  ScrollController _controller = ScrollController();
  DocumentSnapshot content;
  MessageWithPerson messageWithPerson;
  FocusNode myFocusNode;
  final messageController = TextEditingController();


  DocumentReference docRef;


  Container bottomContainer;
  Container messageListViewContainer;


  _MessageRoomPageState(String UID, String userEmail, String chatRoomID,
      String userName, String chatName) {
    this.UID = UID;
    this.userEmail = userEmail;
    this.chatRoomID = chatRoomID;
    this.userName = userName;
    this.chatName = chatName;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // This will get the users name and setstate for when it retrieves it
//    docRef = Firestore.instance.collection('currentUser').document(email);
//    Future function() async {
//      DocumentSnapshot result = await docRef.get();
//      contactName = result["nickname"];
//      print(contactName);
//
//    }
//    function().whenComplete((){
//      setState(() {
//        contactName = contactName;
//      });
//    });




    bottomContainer = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      child: TextField(
                          controller: messageController,
                          focusNode: myFocusNode,
                          onSubmitted: (String valueChanged) {
                            if (messageController.text.isNotEmpty)
                              sendMessage(messageController.text);
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Send a message...'
                          )
                      )
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.album),
                    iconSize: 40,
                  ),
                  IconButton(
                    onPressed: () {
                      String message = messageController.text;
                      print("message: $message");
                      if (message.isNotEmpty) {

                        sendMessage(message);
                      }

                    },
                    icon: Icon(Icons.send),
                    iconSize: 40,
                  )
                ],
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    if(messageController != null) {
      messageController.dispose();
    }
    if(myFocusNode != null){
      myFocusNode.dispose();
    }
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Scaffold scaffold = Scaffold(
      appBar: AppBar(

        title: Text(chatName),
      ),
      body: Container(
        child: Column(
            children: <Widget>[
              StreamBuilder(
                  stream:
                  Firestore.instance.collection('chats')
                      .document(chatRoomID)
                      .collection("chatmessages")
                      .snapshots(),
                  builder: (context, snapshot) {

                    if (!snapshot.hasData) {
                      return Text("Loading...");
                    } else {
                      Timer(Duration(milliseconds: 100), () =>
                          _controller.jumpTo(
                              _controller.position.maxScrollExtent));
                      return
                        Expanded(child: ListView.builder(
                          controller: _controller,
                          padding: EdgeInsets.all(8.0),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int position) {
                            return _getMessages(
                                snapshot.data.documents[position], position,
                                snapshot.data.documents.length);
                          },
                        ),
                        );

                      //return Expanded(child: Container(child: Text("No messages")));
                    }
                  }
              ),

              bottomContainer,
            ]
        ),

      ),
    );


    return scaffold;


  }


  sendMessage(String message) {
    var now = new DateTime.now();

    DocumentReference ref = Firestore.instance.collection('chats')
        .document(chatRoomID).collection("chatmessages").document();

    ref.setData({
      'nickname': userName,
      'id': UID,
      'email': userEmail,
      'message': message,
      'date': now.millisecondsSinceEpoch,
      'sender': userEmail,
      'chat': chatRoomID,
    });

    // We want to update the last message sent on every members chat
    Firestore.instance.collection('chats')
        .document(chatRoomID)
        .collection("members")
        .snapshots().listen((data) =>
        data.documents.forEach((doc) {
          print(doc["title"]);

          DocumentReference ref2 = Firestore.instance.collection('usersChats')
              .document(doc["id"]).collection("chats").document(chatRoomID);

          ref2.updateData({
            'message': message,
            'sender': UID,
            'date': now.millisecondsSinceEpoch,
          });

        }));


    messageController.value = TextEditingValue(text: "");

    _controller.animateTo(_controller.position.maxScrollExtent,
        duration: const Duration(microseconds: 300), curve: Curves.easeOut);
  }


  // ListView for the message content
  Widget _getMessages(DocumentSnapshot document, int position, int length) {
    bool isYou = false;
    if (document["sender"] == userEmail) {
      isYou = true;
    }

    int dateMessage = document['date'];

    String dateString;


    if (dateMessage != null || dateMessage == 1) {
      print("dateMessage: $dateMessage");

      dateString = new DateFormat.yMd().add_jm().format(
          DateTime.fromMillisecondsSinceEpoch(dateMessage));
    }
    //DateTime dateTimemessage = DateTime.fromMicrosecondsSinceEpoch(int.parse(document['date']));



    // this Container has the message
    Container MyMessage = Container(
        padding: EdgeInsets.only(
            left: 14.0, right: 14.0, top: 5.0, bottom: 10.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.lightBlue.shade50),
            )
        ),
        child: Column(children: [
          Text((document['date'] == null) ? "" : dateString),
          Text(
            (document["message"] == null) ? "None" : document["message"])
        ]
        )
    );

    return GestureDetector(
      child: (
      // Is it you ? that sent the message.


          isYou ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyMessage
            ],
          ) : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              MyMessage
            ],

          )),


      onTap: () {

      },
        onHorizontalDragStart: (DragStartDetails details) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Delete Message?"),
                  content: Text(document["message"]),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Yes"),
                      onPressed: () {
                        Firestore.instance.collection("chats").document(
                            chatRoomID).collection("chatmessages").document(
                            document.documentID).delete().then((void hm) {
                          Navigator.of(context).pop();
                        });
                      },

                    )
                  ],
                );
              }
          );
        }


    );
  } //
}