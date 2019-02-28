import 'dart:async';

import 'package:buhaychat/object/MessageWithPerson.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageRoomPage extends StatefulWidget {
  String UID;
  String friendEmail;
  String friendName;
  String userEmail;
  String chatRoomID;
  String userName;
  String friendUID;

  MessageRoomPage(
      {Key key, String UID, String friendEmail, String friendName, String userEmail, String chatRoomID, String userName, String friendUID})
      : super(key: key) {
    this.UID = UID;
    this.friendEmail = friendEmail;
    this.friendName = friendName;
    this.userEmail = userEmail;
    this.chatRoomID = chatRoomID;
    this.userName = userName;
    this.friendUID = friendUID;
  }

  _MessageRoomPageState createState() =>
      _MessageRoomPageState(
          UID, friendEmail, friendName, userEmail, chatRoomID, userName, friendUID);
}

class _MessageRoomPageState extends State<MessageRoomPage> {


  String UID;
  String friendEmail;
  String userEmail;
  DocumentSnapshot content;
  MessageWithPerson messageWithPerson;
  FocusNode myFocusNode;
  String chatRoomID;
  String userName;
  String friendUID;
  ScrollController _controller = ScrollController();

  final messageController = TextEditingController();
  String contactName = "Name";

  DocumentReference docRef;


  Container bottomContainer;
  Container messageListViewContainer;


  _MessageRoomPageState(String contactID, String friendEmail, String friendName,
      String userEmail, String chatRoomID, String userName, String friendUID) {
    this.UID = contactID;
    this.friendEmail = friendEmail;
    this.contactName = friendName;
    this.userEmail = userEmail;
    this.chatRoomID = chatRoomID;
    this.userName = userName;
    this.friendUID = friendUID;
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
                      if (message.isNotEmpty || message != null || message == '') {

                        print("message is : " + message);
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
    // TODO: implement dispose
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

        title: Text(contactName),
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
    DocumentReference ref = Firestore.instance.collection('chats')
        .document(chatRoomID).collection("chatmessages").document();

    ref.setData({
      'nickname': userName,
      'id': UID,
      'email': userEmail,
      'message': message,
      'date': null,
      'sender': userEmail,
      'chat': chatRoomID,
    });



    DocumentReference ref2 = Firestore.instance.collection('userContacts')
        .document(UID).collection("contacts").document(friendEmail);



    ref2.updateData({
      'message': message,
      'sender': UID,
    });

    // updates friends
    DocumentReference ref3 = Firestore.instance.collection('userContacts')
        .document(friendUID).collection("contacts").document(userEmail);


    ref3.updateData({
      'message': message,
      'sender': UID,
    });

    _controller.animateTo(_controller.position.maxScrollExtent,
        duration: const Duration(microseconds: 300), curve: Curves.easeOut);
  }


  // ListView for the message content
  Widget _getMessages(DocumentSnapshot document, int position, int length) {
    bool isYou = false;
    if (document["sender"] == userEmail) {
      isYou = true;
    }

    
    // this Container has the message
    Container MyMessage = Container(
        padding: EdgeInsets.only(
            left: 14.0, right: 14.0, top: 5.0, bottom: 10.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.lightBlue.shade50),
            )
        ),
        child: Text(
            (document["message"] == null) ? "None" : document["message"])
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
    );
  }
}
