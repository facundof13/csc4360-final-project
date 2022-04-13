import 'package:fanpage/pages/home.dart';
import 'package:fanpage/shared.dart';
import 'package:fanpage/custom/forms/signupform.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);
  static const String routeName = '/message';
  @override
  Widget build(BuildContext context) {
    double width = (screenWidth(context) < screenHeight(context) ? 0.95 : 0.5) *
        screenWidth(context);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: width,
          child: Card(
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SignUpForm(onTap: () => _successfulSignUp(context)),
              )),
        ),
      ),
    );
  }

  static void _successfulSignUp(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => HomePage()),
      ModalRoute.withName('/'),
    );
  }
}
