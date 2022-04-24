import 'package:fanpage/custom/forms/postform.dart';
import 'package:fanpage/models/post.dart';
import 'package:fanpage/pages/conversation.dart';
import 'package:fanpage/pages/post.dart';
import 'package:fanpage/pages/post_card.dart';
import 'package:fanpage/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/database_service.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  bool admin = false;
  final DatabaseService db = DatabaseService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    setAdmin();
  }

  void setAdmin() async {
    var user = await db.getUser(auth.currentUser!.uid);
    setState(() {
      admin = (user.type == "ADMIN");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    loading = true;
                    logout();
                  });
                },
                icon: const Icon(Icons.logout),
              ),
            ],
            leading: IconButton(
              icon: const Icon(Icons.message),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConversationPage()),
                )
              },
            )),
        body: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "All Posts",
                  style: TextStyle(fontSize: 20),
                )),
            Expanded(
              child: StreamBuilder<List<Post>>(
                stream: db.posts,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("An error has occurred!"),
                    );
                  } else {
                    var posts = snapshot.data ?? [];

                    return posts.isNotEmpty
                        ? GridView.count(
                            crossAxisCount: 2,
                            children: posts
                                .map((post) => PostCard(post: post))
                                .toList())
                        : const Center(
                            child: Text("No post have been made yet."),
                          );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: messagePopUp,
          tooltip: 'Post Message',
          child: const Icon(Icons.add),
        ));
  }

  void logout() async {
    await auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const SignUpPage()),
      ModalRoute.withName('/'),
    );
  }

  void messagePopUp() {
    showModalBottomSheet<void>(
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return const Padding(
              padding: EdgeInsets.all(30.0), child: PostForm());
        });
  }
}
