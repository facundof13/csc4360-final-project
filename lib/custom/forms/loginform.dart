import 'package:fanpage/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/loading.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final Function onTap;
  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  var form = GlobalKey<FormState>();
  var loading = false;
  var email = TextEditingController();
  var password = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                verticalSpaceSmall,
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter valid email address'),
                  textInputAction: TextInputAction.next, // Moves focus to next.
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Email must have a value.";
                    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/="
                            "?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return "Email in the wrong format.";
                    }
                    return null;
                  },
                ),
                verticalSpaceSmall,
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter password longer than 6 character.'),
                  textInputAction: TextInputAction.done, // Hides the keyboard.
                ),
                verticalSpaceSmall,
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        loading = true;
                        logIn();
                      });
                    },
                    child: const Text("Log In")),
                verticalSpaceSmall,
                TextButton(
                  onPressed: forgotPassword,
                  child: const Text(
                    'Forgot Password? Click Her',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
                verticalSpaceLarge
              ],
            ),
          );
  }

  void logIn() async {
    if (form.currentState!.validate()) {
      try {
        await auth.signInWithEmailAndPassword(
            email: email.text, password: password.text);
        setState(() {
          loading = false;
          widget.onTap();
          Navigator.of(context).pop();
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          snackBar(context, 'The email/password combination is incorrect.');
        } else {
          snackBar(context, e.message ?? "Authentication error.");
        }
        setState(() {
          loading = false;
        });
      } catch (e) {
        snackBar(context, e.toString());
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  void forgotPassword() async {
    try {
      await auth.sendPasswordResetEmail(email: email.text);
      snackBar(context, "Password reset email sent.");
    } on FirebaseAuthException catch (e) {
      snackBar(context, e.message ?? "Authentication error.");
    } catch (e) {
      snackBar(context, e.toString());
    }

    setState(() {
      loading = false;
    });
  }
}
