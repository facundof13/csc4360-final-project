import 'package:fanpage/pages/home.dart';
import 'package:fanpage/pages/select_user.dart';
import 'package:fanpage/shared.dart';
import 'package:fanpage/custom/forms/signupform.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);
  static const String routeName = '/message';

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: messagePopUp,
        tooltip: 'Send Message',
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void messagePopUp() {
    final _formKey = GlobalKey<FormState>();

    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.all(30.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectUserPage(),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Text(
                          "Enter a message",
                        ),
                        TextFormField(),
                        Spacer(),
                        Row(children: [
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: sendMessage,
                                  child: Text("Send Message")))
                        ]),
                      ])));
        });
  }

  void sendMessage() async {
    print('sending user message');
  }
}
