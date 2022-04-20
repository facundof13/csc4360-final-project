import 'package:fanpage/models/conversation.dart';
import 'package:fanpage/models/message.dart';
import 'package:fanpage/pages/chat.dart';
import 'package:fanpage/pages/send_message.dart';
import 'package:fanpage/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class MessagePage extends StatefulWidget {
  const MessagePage({required this.conversation, Key? key}) : super(key: key);
  final Conversation conversation;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final DatabaseService db = DatabaseService();
  ScrollController scrollController = ScrollController();

  void messageSent() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.conversation.userInfo
        .where((user) => user.id != auth.currentUser!.uid)
        .first
        .name;
    return Scaffold(
      appBar: AppBar(
        title: Text(toBeginningOfSentenceCase(title)!),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(value: 0, child: Text("hello")),
                  ])
        ],
      ),
      body: StreamBuilder<List<Message>>(
        stream: db.messages,
        builder: (context, snapshot) {
          var data = snapshot.data ?? [];
          data.removeWhere(
              (message) => message.conversationId != widget.conversation.id);

          return Column(
            children: <Widget>[
              Expanded(
                  child: ChatPage(
                      messages: data, scrollController: scrollController)),
              SendMessagePage(
                  conversationId: widget.conversation.id,
                  messageSent: messageSent),
            ],
          );
        },
      ),
    );
  }
}
