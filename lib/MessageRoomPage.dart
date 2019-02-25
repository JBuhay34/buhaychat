import 'package:buhaychat/object/Message.dart';
import 'package:flutter/material.dart';

class MessageRoomPage extends StatefulWidget {
  MessageContent content;

  MessageRoomPage({Key key, MessageContent content}) : super(key: key) {
    this.content = content;
  }

  _MessageRoomPageState createState() => _MessageRoomPageState(content);
}

class _MessageRoomPageState extends State<MessageRoomPage> {
  MessageContent content;

  _MessageRoomPageState(MessageContent content) {
    this.content = content;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(content.getSender()),
      ),
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        autofocus: true,
                      )),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.send),
                        iconSize: 40,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
