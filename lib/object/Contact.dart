class Contact {
  String date;
  String sender;
  String message;
  bool hasRead;
  String email;

  Contact(this.message, this.sender, this.date, this.hasRead);


  String getSender() => this.sender;

  String getDate() => this.date;

  String getMessage() => this.message;

  bool hasReadMessage() => this.hasRead;

  String getEmail() => this.email;
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