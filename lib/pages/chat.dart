import 'package:fanpage/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {Key? key, required this.messages, required this.scrollController})
      : super(key: key);
  final List<Message> messages;
  final ScrollController scrollController;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      widget.scrollController
          .jumpTo(widget.scrollController.position.maxScrollExtent);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      ListView.builder(
        controller: widget.scrollController,
        itemCount: widget.messages.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        itemBuilder: (context, index) {
          final Message message = widget.messages[index];
          return Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: Align(
                alignment: message.from != auth.currentUser!.uid
                    ? Alignment.topLeft
                    : Alignment.topRight,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: message.from != auth.currentUser!.uid
                          ? Colors.grey.shade200
                          : Colors.blue[200],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(message.message))),
          );
        },
      ),
    ]);
  }
}
