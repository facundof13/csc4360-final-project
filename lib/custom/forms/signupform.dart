import 'package:fanpage/services/database_service.dart';
import 'package:fanpage/custom/forms/loginform.dart';
import 'package:fanpage/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/loading.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final Function onTap;
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  var form = GlobalKey<FormState>();
  var loading = false;
  var email = TextEditingController();
  var displayname = TextEditingController();
  var password = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: Loading())
        : Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: displayname,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Display Name',
                      hintText: 'Enter the name you want people to see.'),
                  textInputAction: TextInputAction.next, // Moves focus to next.
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Display name must have a value.";
                    }
                    return null;
                  },
                ),
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
                        signUp();
                      });
                    },
                    child: const Text("Sign Up")),
                verticalSpaceSmall,
                TextButton(
                  onPressed: showLogin,
                  child: const Text(
                    'Already have an account? Log in here.',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
              ],
            ),
          );
  }

  void signUp() async {
    if (form.currentState!.validate()) {
      try {
        var credential = await auth.createUserWithEmailAndPassword(
            email: email.text, password: password.text);
        credential.user!.sendEmailVerification();
        db
            .setUser(credential.user!.uid, displayname.text, email.text)
            .then((value) {
          setState(() {
            loading = false;
            widget.onTap();
          });
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          snackBar(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          snackBar(context, 'The account already exists for that email.');
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

  void showLogin() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.all(30.0),
              child: LogInForm(onTap: widget.onTap));
        });
  }
}
