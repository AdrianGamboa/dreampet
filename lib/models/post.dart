import 'package:mongo_dart/mongo_dart.dart';

class Post {
  final ObjectId id;
  final String image;
  final String title;
  final String description;
  final DateTime publishedDate;
  final String userId;

  Post(
      {this.id, this.image, this.title, this.description, this.publishedDate, this.userId});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'image': image,
      'title': title,
      'description': description,
      'publishedDate': publishedDate,
      'userId': userId,
    };
  }

  Post.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        image = map['image'],
        title = map['title'],
        description = map['description'],
        publishedDate = map['publishedDate'],
        userId = map['userId'];
}
