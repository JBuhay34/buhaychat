class Contact {
  String time;
  String sender;
  String message;
  bool hasRead;

  Contact(this.message, this.sender, this.time, this.hasRead);


  String getSender() => this.sender;

  String getTime() => this.time;

  String getMessage() => this.message;

  bool hasReadMessage() => this.hasRead;
}

class ContactGenerator {
  static var contactList = [
    Contact("Hello Babe", "Katherine Cariaso", "2:30 PM",
        true),
    Contact("Go Home ka na", "Mom", "31 Oct",
        false),
  ];

  static Contact getContactContent(int position) =>
      contactList[position];
  static int messageListLength = contactList.length;
}