import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String sender;
  final String receiver;
  final String message;
  final DateTime sentDate;

  Chat({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.sentDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'sentDate': Timestamp.fromDate(sentDate),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic date) {
      if (date is Timestamp) {
        return date.toDate();
      } else if (date is String) {
        return DateTime.parse(date);
      } else {
        return DateTime.now();
      }
    }

    return Chat(
      sender: map['sender'],
      receiver: map['receiver'],
      message: map['message'],
      sentDate: parseDate(map['sentDate']),
    );
  }
}
