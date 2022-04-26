import 'package:fanpage/models/conversation.dart';
import 'package:fanpage/models/post.dart';
import 'package:fanpage/pages/message.dart';
import 'package:fanpage/pages/profile.dart';
import 'package:fanpage/services/database_service.dart';
import 'package:fanpage/shared.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

class PostPage extends StatefulWidget {
  static const String routeName = '/post';

  const PostPage({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final DatabaseService db = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late var messageController = TextEditingController(
      text:
          "Hello! I am interested in your ${widget.post.title}, is it still available?");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              onSelected: popupAction,
              itemBuilder: (context) => [
                    if (widget.post.owner != _auth.currentUser!.uid)
                      const PopupMenuItem(
                        value: 0,
                        child: Text("Message Poster"),
                      ),
                    const PopupMenuItem(value: 1, child: Text("View Profile")),
                    if (widget.post.owner == _auth.currentUser!.uid)
                      const PopupMenuItem(child: Text("Delete Post"), value: 2)
                  ])
        ],
      ),
      body: SafeArea(
          child: Expanded(
            child: Container(
              height: 800,
              width: 800,
                  child: Column(children: [
            verticalSpaceMedium,
            CarouselSlider(
              items: widget.post.images!.isNotEmpty
                  ? widget.post.images!.map((img) => Image.network(img)).toList()
                  : [const Text("Please contact the seller for images")],
              options: CarouselOptions(),
            ),
            verticalSpaceMedium,
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.post.tag
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(10),
                              child: Chip(label: Text(e)),
                            ))
                        .toList())),
            verticalSpaceMedium,
            Center(
              child: Text(widget.post.post),
            ),
            verticalSpaceMedium,
            Center(child: Text("Located in ${widget.post.location}")),
                  ]),
                ),
          )),
    );
  }

  void messagePoster() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              const Text("Send a message to this user", textScaleFactor: 1.5),
              verticalSpaceMedium,
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  )),
                  IconButton(
                      onPressed: () => messageUser(),
                      icon: const Icon(Icons.send))
                ],
              ),
            ]),
          );
        });
  }

  Future<void> messageUser() async {
    final String conversationId = await db.createConversation(
      await db.getUser(widget.post.owner),
      messageController.value.text,
    );
    final Conversation c = await db.getConversationById(conversationId);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MessagePage(conversation: c)),
        ModalRoute.withName('/'));
  }

  Future<void> deletePost() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Post?"),
            content: const Text(
                "Are you sure you want to delete this post? This action cannot be undone."),
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey.shade300),
                      foregroundColor: MaterialStateProperty.all(Colors.black)),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () async {
                    await db.deletePost(widget.post.id);
                    Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  child: const Text("Delete")),
            ],
          );
        });
  }

  Future<void> popupAction(val) async {
    switch (val) {
      case 0:
        messagePoster();
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(userId: widget.post.owner)));
        break;
      case 2:
        await deletePost();
        break;
      default:
    }
  }
}
