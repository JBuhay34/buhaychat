import 'package:buhaychat/AddContactPage.dart';
import 'package:buhaychat/CreateChatRoomPage.dart';
import 'package:buhaychat/MessageRoomPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainAppPage extends StatefulWidget {
  String UID;
  String email;
  String userName;

  MainAppPage({Key key, String UID, String email, userName}) : super(key: key){

    this.UID = UID;
    this.email = email;
    this.userName = userName;
  }

  @override
  _MainPageState createState() => _MainPageState(UID, email, userName);
}

class _MainPageState extends State<MainAppPage> {

  String userProfilePic = "";
  String UID;
  String email;
  String friendNameClicked;
  String userName;

  _MainPageState(String UID, String email, String userName){
    this.UID = UID;
    this.email = email;
    this.userName = userName;
  }


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


  FirebaseUser firebaseUser;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();


    firebaseAuth
        .currentUser()
        .then((value) async {
      firebaseUser = value;

      setState(() {
        userProfilePic = firebaseUser.photoUrl;
      });
    });

    }

    var text = Text("Messages");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: text,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                //Add contact
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddContactPage(UID: UID)),
                  );
                }
            )
          ]
      ),
      drawer: drawer,
      body: StreamBuilder(
          stream:
          Firestore.instance.collection('userContacts').document(UID).collection("contacts").snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Text("Loading...");
            } else{
              return

                ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int position) {
                    return _getRow(snapshot.data.documents[position]);
                  });
            }
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // dont implement yet
//          Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => CreateChatRoomPage(UID: UID, email: email)),
//          );

        },
        child: Icon(Icons.message),
      ),
    );
  }

  String friendEmail;
  String chatRoomID;
// ListView for the message content
  Widget _getRow(DocumentSnapshot document) {

    friendNameClicked =document['nickname'];
    friendEmail = document['email'];
    chatRoomID = document['chat'];


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
                                (document['nickname'] == null) ? " ": document['nickname'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                    fontSize: 17.0),
                              ),
                              Text(
                                (document['date'] == null) ? " ": document['date'],
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
                                    (document['message'] == null) ? "No messages yet" : document['message'],
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
            MaterialPageRoute(builder: (context) => MessageRoomPage(friendUID:document['id'],UID: UID, friendEmail: friendEmail, friendName: friendNameClicked, chatRoomID: chatRoomID, userEmail: email, userName: userName)),
          );

          setState(() {
            // setState, when you want to refresh the ListView(notifyDataSetChanged)
          }
          );
        }
    );
  } // getRow()
} // _MainPageState


