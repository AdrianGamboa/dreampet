import 'package:mongo_dart/mongo_dart.dart';

class Post {
  final ObjectId id;
  final String image;
  final String description;
  final DateTime publishedDate;
  final String userId;

  Post(
      {this.id, this.image, this.description, this.publishedDate, this.userId});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'image': image,
      'description': description,
      'publishedDate': publishedDate,
      'userId': userId,
    };
  }

  Post.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        image = map['image'],
        description = map['description'],
        publishedDate = map['publishedDate'],
        userId = map['userId'];
}
