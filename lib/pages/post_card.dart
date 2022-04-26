import 'package:fanpage/models/post.dart';
import 'package:fanpage/pages/post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final f = DateFormat('MMMM dd, yyy');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostPage(
                      post: widget.post,
                    )),
          );
        },
        child: Container(
            padding: const EdgeInsets.all(10),
            child: Card(
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      widget.post.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                if (widget.post.images != null &&
                    widget.post.images!.isNotEmpty)
                  Expanded(
                      child: Image.network(
                    widget.post.images![0],
                  ))
                else
                  const Spacer(),
                if (widget.post.tag.isNotEmpty)
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.post.tag
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Chip(label: Text(e)),
                                  ))
                              .toList())),
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text("Posted on " +
                        f
                            .format(DateTime.parse(widget.post.created))
                            .toString())),
              ]),
            )));
  }
}
