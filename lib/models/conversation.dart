import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  Conversation({
    required this.id,
    required this.created,
    required this.users,
  });

  factory Conversation.fromMap(String id, Map<String, dynamic> data) {
    return Conversation(
      id: id,
      users: data['users'],
      created: data['created'],
    );
  }
  Map<String, dynamic> toJson() => {
        'users': users,
        'created': created,
      };

  final String id;
  final Timestamp created;
  final List users;
  final userInfo = [];
}
