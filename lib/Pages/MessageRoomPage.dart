import 'dart:async';

import 'package:buhaychat/AppColors.dart';
import 'package:buhaychat/Pages/MembersOfChatPage.dart';
import 'package:buhaychat/object/MessageWithPerson.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:intl/intl.dart";



//void sendMessageFirebase(Map<String, String> params){
//
//  CloudFunctions.instance.call(functionName: 'sendMessageToGroupChat', parameters: params);
//
//}

class MessageRoomPage extends StatefulWidget {
  String UID;
  String userEmail;
  String chatRoomID;
  String userName;
  String chatName;
  String userPhotoUrl;

  MessageRoomPage(
      {Key key, String UID, String userEmail, String chatRoomID, String userName, String chatName, String userPhotoUrl})
      : super(key: key) {
    this.UID = UID;
    this.userEmail = userEmail;
    this.chatRoomID = chatRoomID;
    this.userName = userName;
    this.chatName = chatName;
    this.userPhotoUrl = userPhotoUrl;
  }

  _MessageRoomPageState createState() =>
      _MessageRoomPageState(
          UID, userEmail, chatRoomID, userName, chatName, userPhotoUrl);
}

class _MessageRoomPageState extends State<MessageRoomPage> {


  String UID;
  String userEmail;
  String chatRoomID;
  String userName;
  String chatName = "Name";
  String userPhotoUrl;

  ScrollController _controller = ScrollController();
  DocumentSnapshot content;
  MessageWithPerson messageWithPerson;
  FocusNode myFocusNode;
  final messageController = TextEditingController();


  DocumentReference docRef;


  Container bottomContainer;
  Container messageListViewContainer;


  _MessageRoomPageState(String UID, String userEmail, String chatRoomID,
      String userName, String chatName, String userPhotoUrl) {
    this.UID = UID;
    this.userEmail = userEmail;
    this.chatRoomID = chatRoomID;
    this.userName = userName;
    this.chatName = chatName;
    this.userPhotoUrl = userPhotoUrl;
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

    // sometimes firebase doesn't completely get the photoUrl or userName
    if(userPhotoUrl == null || userPhotoUrl == "" || userName == null || userName == ""){

      FirebaseAuth.instance.currentUser().then((value) async {
        FirebaseUser firebaseUser = value;

        UID = await firebaseUser.uid;
        userEmail = await firebaseUser.email;
        userPhotoUrl = await firebaseUser.photoUrl;
        userName = await firebaseUser.displayName;
        });
    }


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
                        cursorColor: AppColors.textColor,
                          autocorrect: true,
                          style: TextStyle(color: AppColors.textColor),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          controller: messageController,
                          focusNode: myFocusNode,
                          onSubmitted: (String valueChanged) {
                            if (messageController.text.isNotEmpty)
                              sendMessage(messageController.text);
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Send a message...',
                            hintStyle: TextStyle(color:Colors.grey),
                          )
                      )
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.album,color: AppColors.accentColor,),
                    iconSize: 40,
                  ),
                  IconButton(
                    onPressed: () {
                      String message = messageController.text;
                      if (message.isNotEmpty) {

                        sendMessage(message);
                      }

                    },
                    icon: Icon(Icons.send, color: AppColors.accentColor),
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
        backgroundColor: AppColors.primaryColor,
        title: Text(chatName),
        actions: <Widget>[
          IconButton(icon: new Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    MembersOfChatPage(UID: UID,
                        userEmail: userEmail,
                        userName: userName,
                        userPhotoUrl: userPhotoUrl,
                        chatRoomID: chatRoomID,
                        chatName: chatName)),
              );
            },)
          ,
        ],
      ),
      body: Container(
        color: AppColors.backgroundColor,
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

  // ListView for the message content
  Widget _getMessages(DocumentSnapshot document, int position, int length) {
    bool isYou = false;
    if (document["sender"] == userEmail) {
      isYou = true;
    }

    String message = document["message"];
    String photoUrl = document["photoUrl"];

    int dateMessage = document['date'];
    DateTime now = DateTime.now();
    String dateString;

    // Check if the message is from today, just show the time
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




    //DateTime dateTimemessage = DateTime.fromMicrosecondsSinceEpoch(int.parse(document['date']));


    final bg = isYou ? AppColors.primaryColor : AppColors.bubbleThem;
    final align = isYou ? MainAxisAlignment.end : MainAxisAlignment.start;
    final radius = (!isYou) ? BorderRadius.only(
      topRight: Radius.circular(5.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(5.0),
    )
        : BorderRadius.only(
      topLeft: Radius.circular(5.0),
      bottomLeft: Radius.circular(5.0),
      bottomRight: Radius.circular(10.0),
    );

    // this Container has the message
    Container MyMessage = Container(
      padding: EdgeInsets.all(8.0),
        child:Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: align,
            children: <Widget>[
              Text((document['date'] == null) ? "" : dateString,
            style: TextStyle(
              color: AppColors.textColor,
              fontFamily: 'Roboto'
            ),
          ),
            ],
          ),


            Row(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width-200),
                    child:Text(
                      (message == null) ? "None" : message,
                      style: TextStyle(
                          color: AppColors.textColor,
                          fontFamily: 'Roboto'
                      ),
                )
                )
              ],
            ),


        ]
        )
    );

    Row mainChild = (isYou) ? Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: align,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          child: Container(
            child: MyMessage,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 1.0,
                    color: Colors.black.withOpacity(.12))
              ],
              color: bg,
              borderRadius: radius,
            ),
          ), padding:
           EdgeInsets.all(12.0),
        ),
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


      ],

    ) : Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: align,
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
        Padding(
          child: Container(
            child: MyMessage,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 1.0,
                    color: Colors.black.withOpacity(.12))
              ],
              color: bg,
              borderRadius: radius,
            ),
          ), padding: EdgeInsets.all(12.0),
        ),


      ],

    );

    return GestureDetector(

        child: mainChild,
      onTap: () {

      },
        onLongPress: () async {
          if(isYou){
            await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
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
        }


    );
  } // end _get_Messages


  sendMessage(String message) {
    var now = new DateTime.now();

    DocumentReference ref = Firestore.instance.collection('chats')
        .document(chatRoomID).collection("chatmessages").document();


//    HashMap chatDetails = HashMap();
//    chatDetails.putIfAbsent('chat', () {
//      return chatRoomID;
//    }
//    print("chatDetails: " + chatDetails.toString());


    ref.setData({
      'photoUrl': userPhotoUrl,
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

          DocumentReference ref2 = Firestore.instance.collection('usersChats')
              .document(doc["id"]).collection("chats").document(chatRoomID);

          ref2.updateData({
            'message': message,
            'sender': UID,
            'senderName': userName,
            'date': now.millisecondsSinceEpoch,
            'photoUrl': userPhotoUrl,
          });
        }));



    messageController.value = TextEditingValue(text: "");

    _controller.animateTo(_controller.position.maxScrollExtent,
        duration: const Duration(microseconds: 300), curve: Curves.easeOut);
  } // end sendMessage
}
