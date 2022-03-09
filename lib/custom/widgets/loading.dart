import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({this.message, Key? key}) : super(key: key);
  final String? message;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      message != null ? Text(message!) : Container(),
      const CircularProgressIndicator()
    ]));
  }
}
