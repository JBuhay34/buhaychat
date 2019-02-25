import 'package:buhaychat/Message.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Messages",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {


  var drawer = new Drawer(
      child: new ListView(
        children: <Widget>[
          new DrawerHeader(child: new Text("BuhayMessage"),
            decoration: new BoxDecoration(
                color: Colors.blue
            ),
          ),
          new Text("Sign out"),
          new Text("Import Contacts")
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
            new IconButton(
                icon: new Icon(Icons.add),
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
        floatingActionButton: new FloatingActionButton(
          onPressed: (){},
          child: new Icon(Icons.message),
        ),
    );
  }

// ListView for the message content
  Column getRow(int i) {
    MessageContent messageContent = MessageGenerator.getMessageContent(i);
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(
            left: 14.0, right: 14.0, top: 5.0, bottom: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 55.0,
              color: Colors.red,
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
                          messageContent.getTime(),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                              fontSize: 17.0),
                        ),
                        Text(
                            messageContent.getMessage(),
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
                              messageContent.getSender(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                  fontSize: 15.5),
                            ),
                          ],
                        ),
                        new Icon(Icons.check)
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
    );
  }

}


