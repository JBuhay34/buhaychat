class MessageContent {
  String time;
  String sender;
  String message;
  bool hasRead;

  MessageContent(this.message, this.sender, this.time, this.hasRead);


  String getSender() => this.sender;

  String getTime() => this.time;

  String getMessage() => this.message;

  bool hasReadMessage() => this.hasRead;
}

class MessageGenerator {
  static var messageList = [
    MessageContent("Hello Babe", "Katherine Cariaso", "2:30 PM",
        true),
    MessageContent("Go Home ka na", "Mom", "31 Oct",
        false),
  ];

  static MessageContent getMessageContent(int position) =>
      messageList[position];
  static int messageListLength = messageList.length;
}