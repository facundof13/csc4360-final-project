import 'package:fanpage/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import '../models/user.dart';

class SelectUserPage extends StatefulWidget {
  const SelectUserPage({required this.callback, Key? key}) : super(key: key);
  final Function callback;

  @override
  State<SelectUserPage> createState() => SelectUserPageState();
}

class SelectUserPageState extends State<SelectUserPage> {
  final DatabaseService db = DatabaseService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, User>>(
      stream: db.users,
      builder: (context, snapshot) {
        var users = snapshot.data?.values.toList() ?? [];
        users.removeWhere((element) => element.id == auth.currentUser?.uid);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select a user",
            ),
            Row(
              children: [
                Expanded(
                    child: DropdownButton<User>(
                  isExpanded: true,
                  items: users
                      .map((e) => DropdownMenuItem(
                            child: Text(e.name),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (User? user) {
                    setState(() {
                      dropdownValue = user!;
                      widget.callback(user);
                    });
                  },
                  value: dropdownValue,
                ))
              ],
            )
          ],
        );
      },
    );
  }
}
