import 'package:buhaychat/AddContactPage.dart';
import 'package:buhaychat/MessageRoomPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateChatRoomPage extends StatefulWidget {
  String UID;
  String email;
  CreateChatRoomPage({Key key, String UID, String email}) : super(key: key){

    this.UID = UID;
    this.email = email;
  }

  @override
  _CreateChatRoomPageState createState() => _CreateChatRoomPageState(UID, email);
}

class _CreateChatRoomPageState extends State<CreateChatRoomPage> {

  String UID;
  String email;
  _CreateChatRoomPageState(String UID, String email){
    this.UID = UID;
    this.email = email;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }


}