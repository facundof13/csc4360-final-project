import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.id,
    required this.from,
    required this.message,
    required this.dateSent,
    required this.conversationId,
  });

  factory Message.fromMap(String id, Map<String, dynamic> data) {
    return Message(
      id: id,
      from: data['from'],
      message: data['message'],
      dateSent: data['dateSent'],
      conversationId: data['conversationId'],
    );
  }
  Map<String, dynamic> toJson() => {
        'from': from,
        'message': message,
        'dateSent': dateSent,
        'conversationId': conversationId,
      };

  final String id;
  final String conversationId;
  final Timestamp dateSent;
  final String message;
  final String from;
}
