import 'package:fanpage/models/conversation.dart';
import 'package:fanpage/models/user.dart';
import 'package:fanpage/pages/conversation.dart';
import 'package:fanpage/pages/home.dart';
import 'package:fanpage/pages/select_user.dart';
import 'package:fanpage/services/database_service.dart';
import 'package:fanpage/shared.dart';
import 'package:fanpage/custom/forms/signupform.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);
  static const String routeName = '/message';

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final messageController = TextEditingController();
  final DatabaseService db = DatabaseService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Conversation>>(
        stream: db.conversations,
        builder: (context, snapshot) {
          var conversations = snapshot.data ?? [];

          conversations.removeWhere(
              (element) => !element.users.contains(auth.currentUser?.uid));

          return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConversationPage()),
                  ),
                  child: Card(
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Conversation with " +
                            conversations[index]
                                .userInfo
                                .map((e) => e.name)
                                .join(', ')),
                      )),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: messagePopUp,
        tooltip: 'Send Message',
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void messagePopUp() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    SelectUserPage(callback: (user) => selectedUser = user),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    const Text(
                      "Enter a message",
                    ),
                    TextFormField(
                      controller: messageController,
                    ),
                    const Spacer(),
                    Row(children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: sendMessage,
                              child: const Text("Send Message")))
                    ]),
                  ])));
        });
  }

  void sendMessage() async {
    db.sendMessage(selectedUser!, messageController.value.text);
    Navigator.pop(context);
  }
}
