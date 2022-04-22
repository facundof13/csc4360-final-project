import 'package:fanpage/models/post.dart';
import 'package:fanpage/pages/post.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
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
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      widget.post.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                if (widget.post.images.isNotEmpty)
                  Container(
                      padding: const EdgeInsets.all(10),
                      child: Image.network(
                        widget.post.images[0],
                        width: 100,
                      ))
              ]),
            )));
  }
}
