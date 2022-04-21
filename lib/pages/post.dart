import 'package:fanpage/models/post.dart';
import 'package:fanpage/pages/home.dart';
import 'package:fanpage/shared.dart';
import 'package:fanpage/custom/forms/signupform.dart';
import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  final Post post;
  const PostPage({Key? key, required this.post}) : super(key: key);

  static const String routeName = '/post';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
        centerTitle: true,
      ),
      body: Text(post.post),
    );
  }

  static void _successfulSignUp(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => HomePage()),
      ModalRoute.withName('/'),
    );
  }
}
