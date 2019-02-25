import 'package:buhaychat/MessageRoomPage.dart';
import 'package:buhaychat/object/Message.dart';
import 'package:flutter/material.dart';

class MainAppPage extends StatefulWidget {
  MainAppPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainAppPage> {


  var drawer = new Drawer(
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

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Messages"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: (){}
            )
          ]
      ),
      drawer: drawer,
      body: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: MessageGenerator.messageList.length,
          itemBuilder: (BuildContext context, int position) {
            return getRow(position);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.message),
      ),
    );
  }

// ListView for the message content
  Widget getRow(int i) {
    MessageContent messageContent = MessageGenerator.getMessageContent(i);
    return GestureDetector(
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: 14.0, right: 14.0, top: 5.0, bottom: 5.0),
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
                              messageContent.getSender(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                  fontSize: 17.0),
                            ),
                            Text(
                              messageContent.getTime(),
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
                                  messageContent.getMessage(),
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MessageRoomPage(content: messageContent)),
          );

          setState(() {
            // setState, when you want to refresh the ListView(notifyDataSetChanged)
          }
          );
        }
    );
  } // getRow()
} // _MainPageState


