class MessageContent {
  String time;
  String sender;
  String message;
  bool hasRead;

  MessageContent(this.sender, this.time, this.message, this.hasRead);


  String getSender() => this.sender;

  String getTime() => this.time;

  String getMessage() => this.message;

  bool hasReadMessage() => this.hasRead;
}

class MessageGenerator {
  static var messageList = [
    MessageContent("Happy Halloween", "John Doe", "2:30 PM",
        true),
    MessageContent("Happy Halloween", "John Doe", "31 Oct",
        false),
  ];

  static MessageContent getMessageContent(int position) =>
      messageList[position];
  static int messageListLength = messageList.length;
}