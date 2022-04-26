import 'package:fanpage/custom/widgets/loading.dart';
import 'package:fanpage/models/user.dart';
import 'package:fanpage/services/database_service.dart';
import 'package:fanpage/shared.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.userId}) : super(key: key);
  static const routeName = '/profile';
  final String userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final DatabaseService db = DatabaseService();
  final f = DateFormat('MMMM dd, yyy');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db.getUser(widget.userId),
        builder: (context, AsyncSnapshot<User> snapshot) {
          final user = snapshot.data;

          if (snapshot.connectionState != ConnectionState.done) {
            return const Loading();
          }

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(user!.name),
              actions: [
                PopupMenuButton(
                  onSelected: popupAction,
                  itemBuilder: (context) => [
                    if (user.id != auth.currentUser!.uid)
                      const PopupMenuItem(
                        child: Text("Report Abuse"),
                        value: 0,
                      )
                  ],
                )
              ],
            ),
            body: SafeArea(
                child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Username: " + user.name,
                    textScaleFactor: 1.2,
                  ),
                  verticalSpaceSmall,
                  Text(
                    "Date Joined: " +
                        f
                            .format(DateTime.parse(
                                DateTime.fromMillisecondsSinceEpoch(
                                        user.created.millisecondsSinceEpoch)
                                    .toString()))
                            .toString(),
                    textScaleFactor: 1.2,
                  ),
                  verticalSpaceSmall,
                  Text(
                    "Email: " + user.email,
                    textScaleFactor: 1.2,
                  ),
                  verticalSpaceMedium,
                  FutureBuilder(
                      // future: ,
                      builder: (context, snapshot) {
                    return Text("");
                  })
                ],
              ),
              padding: const EdgeInsets.all(10),
            )),
          );
        });
  }

  void popupAction(val) {
    switch (val) {
      case 0: // report abuse
        showDialog(
            context: context,
            builder: (context) {
              var commentController = TextEditingController();

              return AlertDialog(
                title: const Text("Report Abuse"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Report abuse against this user."),
                    verticalSpaceMedium,
                    TextField(
                        controller: commentController,
                        decoration: const InputDecoration(hintText: "Comment")),
                  ],
                ),
                actions: [
                  ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey.shade300)),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel")),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
                      onPressed: () async {
                        await db.reportAbuse(
                            widget.userId,
                            auth.currentUser!.uid,
                            commentController.value.text);
                        Navigator.of(context).pop();
                      },
                      child: const Text("Report Abuse")),
                ],
              );
            });
        break;
      default:
    }
  }
}
