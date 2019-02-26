class MessageWithPerson {
  String time;
  String contact;
  String message;
  bool hasRead;
  bool isYou;


  MessageWithPerson(this.message, this.contact, this.time, this.hasRead, this.isYou);


  String getContact() => this.contact;

  String getTime() => this.time;

  String getMessage() => this.message;

  bool hasReadMessage() => this.hasRead;

  bool isItYou() => this.isYou;
}

class MessageWithPersonGenerator{
  static var messageList = [
    MessageWithPerson("Hello Babe", "Katherine Cariaso", "2:30 PM",
        true, false),
    MessageWithPerson("I love You", "Katherine Cariaso", "31 Oct",
        false, true),
    MessageWithPerson("Hello Babe", "Katherine Cariaso", "2:30 PM",
        true, false),
    MessageWithPerson("I love You", "Katherine Cariaso", "31 Oct",
        false, true),
    MessageWithPerson("Hello Babe", "Katherine Cariaso", "2:30 PM",
        true, false),
    MessageWithPerson("I love You", "Katherine Cariaso", "31 Oct",
        false, true),
    MessageWithPerson("Hello Babe", "Katherine Cariaso", "2:30 PM",
        true, false),
    MessageWithPerson("I love You", "Katherine Cariaso", "31 Oct",
        false, true),
    MessageWithPerson("Hello Babe", "Katherine Cariaso", "2:30 PM",
        true, false),
    MessageWithPerson("I love You", "Katherine Cariaso", "31 Oct",
        false, true),
  ];

  static MessageWithPerson getMessageWithPersonContent(int position) =>
      messageList[position];
  static int messageListLength = messageList.length;
}