import 'package:fanpage/services/database_service.dart';
import 'package:fanpage/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/loading.dart';

class PostForm extends StatefulWidget {
  const PostForm({
    Key? key,
  }) : super(key: key);
  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  var loading = false;

  var title = TextEditingController();
  var description = TextEditingController();
  var location = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final DatabaseService db = DatabaseService();
  final List<String> tagList = [
    "Computer",
    "Auto",
    "Home",
    "Furniture",
    "Kitchen",
    "Antiques"
  ];

  List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    tagList.sort();
    return loading
        ? const Loading()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: title,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
              verticalSpaceSmall,
              TextField(
                controller: description,
                minLines: 4,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
              verticalSpaceSmall,
              TextField(
                controller: location,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Location',
                ),
              ),
              verticalSpaceSmall,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: tagList
                      .map(
                        (tag) => GestureDetector(
                            onTap: () => setState(() {
                                  if (selectedTags.contains(tag)) {
                                    selectedTags.remove(tag);
                                  } else {
                                    selectedTags.add(tag);
                                  }
                                }),
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Chip(
                                  label: Text(tag),
                                  backgroundColor: selectedTags.contains(tag)
                                      ? Colors.blue.shade300
                                      : Colors.grey.shade300,
                                ))),
                      )
                      .toList(),
                ),
              ),
              verticalSpaceLarge,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey.shade300)),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel Post")),
                  ElevatedButton(
                      onPressed: createPost, child: const Text("Post Message")),
                ],
              ),
              verticalSpaceRegular
            ],
          );
  }

  void createPost() async {
    bool isValid = true;
    List<String> errors = [];

    if (title.value.text.isEmpty) {
      errors.add("A title must be specified!");
    }

    if (description.value.text.isEmpty) {
      errors.add("A description must be specified!");
    }

    if (location.value.text.isEmpty) {
      errors.add("A location must be specified!");
    }

    if (selectedTags.isEmpty) {
      errors.add("At least one category must be specified!");
    }

    if (errors.isNotEmpty) {
      Fluttertoast.showToast(
          fontSize: 20,
          gravity: ToastGravity.TOP,
          webPosition: "center",
          msg: errors.join('\n'),
          backgroundColor: Colors.red,
          webBgColor: "red",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          webShowClose: true);
    } else {
      await db.createPosting({
        'title': title.value.text,
        'post': description.value.text,
        'selectedTags': selectedTags,
        'images': [],
        'created': DateTime.now(),
        'location': location.value.text,
      });
    }
  }
}
