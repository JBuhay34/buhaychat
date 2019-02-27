import 'package:buhaychat/object/Contact.dart';
import 'package:buhaychat/object/MessageWithPerson.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRoomPage extends StatefulWidget {
  DocumentSnapshot content;

  MessageRoomPage({Key key, DocumentSnapshot content}) : super(key: key) {
    this.content = content;
  }

  _MessageRoomPageState createState() => _MessageRoomPageState(content);
}

class _MessageRoomPageState extends State<MessageRoomPage> {

  DocumentSnapshot content;
  MessageWithPerson messageWithPerson;
  FocusNode myFocusNode;
  final messageController = TextEditingController();

  Container bottomContainer;
  Container messageListViewContainer;

  _MessageRoomPageState(DocumentSnapshot snapshot) {
    this.content = content;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode = FocusNode();
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
    messageController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(content['sender']),
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
