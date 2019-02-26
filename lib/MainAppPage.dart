import 'package:buhaychat/MessageRoomPage.dart';
import 'package:buhaychat/object/Contact.dart';
import 'package:flutter/material.dart';

class MainAppPage extends StatefulWidget {
  MainAppPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainAppPage> {


  Drawer drawer = new Drawer(
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
          itemCount: ContactGenerator.contactList.length,
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
    Contact contactContent = ContactGenerator.getContactContent(i);
    return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color:Colors.lightBlue.shade50)
            )
          ),
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
                              contactContent.getSender(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                  fontSize: 17.0),
                            ),
                            Text(
                              contactContent.getTime(),
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
                                  contactContent.getMessage(),
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
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MessageRoomPage(content: contactContent)),
          );

          setState(() {
            // setState, when you want to refresh the ListView(notifyDataSetChanged)
          }
          );
        }
    );
  } // getRow()
} // _MainPageState


