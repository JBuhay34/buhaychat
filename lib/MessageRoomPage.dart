import 'package:buhaychat/object/Contact.dart';
import 'package:buhaychat/object/MessageWithPerson.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRoomPage extends StatefulWidget {
  String contactID;

  MessageRoomPage({Key key, String contactID}) : super(key: key) {
    this.contactID = contactID;
  }

  _MessageRoomPageState createState() => _MessageRoomPageState(contactID);
}

class _MessageRoomPageState extends State<MessageRoomPage> {

  String contactID;
  DocumentSnapshot content;
  MessageWithPerson messageWithPerson;
  FocusNode myFocusNode;
  final messageController = TextEditingController();
  String contactName = "Name";

  DocumentReference docRef;


  Container bottomContainer;
  Container messageListViewContainer;

  _MessageRoomPageState(String contactID) {
    this.contactID = contactID;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // This will get the users name and setstate for when it retrieves it
    docRef = Firestore.instance.collection('currentUser').document(contactID);
    Future function() async {
      DocumentSnapshot result = await docRef.get();
      contactName = result["name"];
      print(contactName);

    }
    function().whenComplete((){
      setState(() {
        contactName = contactName;
      });
    });

    messageListViewContainer = Container(
      child: ListView.builder(
        itemCount: MessageWithPersonGenerator.messageListLength,
        itemBuilder: (BuildContext context, int position) {
          return getRow(position);
        },
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.lightBlue.shade50,)
          )
      ),
    );


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
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              // Retrieve the text the user has typed in using our
                              // TextEditingController
                              content: Text(messageController.text),
                            );
                          });
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
              Expanded(child: messageListViewContainer,),

              bottomContainer,
            ]
        ),

      ),
    );


    return scaffold;


  }


  // ListView for the message content
  Widget getRow(int i) {

    MessageWithPerson messageContent = MessageWithPersonGenerator
        .getMessageWithPersonContent(i);
    
    // this Container has the message
    Container MyMessage = Container(
        padding: EdgeInsets.only(
            left: 14.0, right: 14.0, top: 5.0, bottom: 10.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.lightBlue.shade50),
            )
        ),
        child: Text(messageContent.getMessage())
    );



    return GestureDetector(
      child: (
      // Is it you ? that sent the message.
          messageContent.isYou ? Row(
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
