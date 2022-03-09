import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage/models/post.dart';
import 'package:fanpage/models/user.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Map<String, User> userMap = <String, User>{};

  final StreamController<Map<String, User>> _usersController =
      StreamController<Map<String, User>>();

  final StreamController<List<Post>> _postsController =
      StreamController<List<Post>>();

  DatabaseService() {
    _firestore.collection('users').snapshots().listen(_usersUpdated);
    _firestore.collection('posts').snapshots().listen(_postsUpdated);
  }

  Stream<Map<String, User>> get users => _usersController.stream;
  Stream<List<Post>> get posts => _postsController.stream;

  void _usersUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    var users = _getUsersFromSnapshot(snapshot);
    _usersController.add(users);
  }

  void _postsUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    var posts = _getPostsFromSnapshot(snapshot);
    _postsController.add(posts);
  }

  Map<String, User> _getUsersFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (var element in snapshot.docs) {
      User user = User.fromMap(element.id, element.data());
      userMap[user.id] = user;
    }

    return userMap;
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
}
