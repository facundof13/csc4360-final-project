import 'package:fanpage/services/database_service.dart';
import 'package:flutter/material.dart';

class SendMessagePage extends StatefulWidget {
  const SendMessagePage(
      {Key? key, required this.conversationId, required this.messageSent})
      : super(key: key);
  final String conversationId;
  final Function messageSent;
  @override
  State<SendMessagePage> createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  final DatabaseService db = DatabaseService();
  var messageController = TextEditingController();

  Future<void> sendMessage() async {
    await db.sendMessage(messageController.value.text, widget.conversationId);

    messageController.text = '';
    widget.messageSent();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: const InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              onPressed: () {
                sendMessage();
              },
              mini: true,
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              backgroundColor: Colors.blue,
              elevation: 0,
            ),
          ],
        ));
  }
}
