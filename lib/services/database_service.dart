import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage/models/conversation.dart';
import 'package:fanpage/models/post.dart';
import 'package:fanpage/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static Map<String, User> userMap = <String, User>{};

  final StreamController<Map<String, User>> _usersController =
      StreamController<Map<String, User>>();

  final StreamController<List<Post>> _postsController =
      StreamController<List<Post>>();

  final StreamController<List<Conversation>> _conversationsController =
      StreamController<List<Conversation>>();

  DatabaseService() {
    _firestore.collection('users').snapshots().listen(_usersUpdated);
    _firestore.collection('posts').snapshots().listen(_postsUpdated);
    _firestore
        .collection('conversations')
        .snapshots()
        .listen(_conversationsUpdated);
  }

  Stream<Map<String, User>> get users => _usersController.stream;
  Stream<List<Post>> get posts => _postsController.stream;
  Stream<List<Conversation>> get conversations =>
      _conversationsController.stream;

  void _usersUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    var users = _getUsersFromSnapshot(snapshot);
    _usersController.add(users);
  }

  void _postsUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    var posts = _getPostsFromSnapshot(snapshot);
    _postsController.add(posts);
  }

  void _conversationsUpdated(
      QuerySnapshot<Map<String, dynamic>> snapshot) async {
    var conversations = await _getConversationsFromSnapshot(snapshot);
    _conversationsController.add(conversations);
  }

  Map<String, User> _getUsersFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (var element in snapshot.docs) {
      User user = User.fromMap(element.id, element.data());
      userMap[user.id] = user;
    }

    return userMap;
  }

  Future<List<Conversation>> _getConversationsFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) async {
    List<Conversation> conversations = [];

    for (var element in snapshot.docs) {
      Conversation c = Conversation.fromMap(element.id, element.data());
      for (var uid in c.users) {
        c.userInfo.add(await getUser(uid));
      }

      conversations.add(c);
    }

    return conversations;
  }

  List<Post> _getPostsFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Post> posts = [];
    for (var element in snapshot.docs) {
      Post post = Post.fromMap(element.id, element.data());
      posts.add(post);
    }
    posts.sort((a, b) => a.created.compareTo(b.created));
    return posts;
  }

  Future<User> getUser(String uid) async {
    var snapshot = await _firestore.collection("users").doc(uid).get();

    return User.fromMap(snapshot.id, snapshot.data()!);
  }

  Future<void> setUser(String uid, String displayName, String email) async {
    await _firestore.collection("users").doc(uid).set({
      "name": displayName,
      "type": "USER",
      "email": email,
      "created": DateTime.now()
    });
    return;
  }

  Future<void> addPost(String uid, String message) async {
    await _firestore.collection("posts").add({
      'message': message,
      'type': 0,
      'owner': uid,
      "created": DateTime.now()
    });
    return;
  }

  Future<void> sendMessage(User selectedUser, String message) async {
    await _firestore.collection("conversations").add({
      'users': [selectedUser.id, _auth.currentUser!.uid],
      "created": DateTime.now()
    });
  }
}
