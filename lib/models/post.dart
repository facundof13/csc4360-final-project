import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post(
      {required this.id,
      required this.post,
      required this.title,
      required this.tag,
      required this.location,
      required this.owner,
      required this.images,
      required this.created});

  factory Post.fromMap(String id, Map<String, dynamic> data) {
    return Post(
      id: id,
      post: data['post'],
      images: data['images'],
      owner: data['owner'],
      created: data['created'],
      location: data['location'],
      title: data['title'],
      tag: data['tag'],
    );
  }
  Map<String, dynamic> toJson() => {
        'location': location,
        'tag': tag,
        'images': images,
        'message': post,
        'owner': owner,
        'created': created,
        'title': title,
      };

  final String id;
  final String post;
  final List<dynamic>? images;
  final String owner;
  final String created;
  final String location;
  final List<dynamic> tag;
  final String title;
}
