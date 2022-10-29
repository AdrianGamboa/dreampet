import 'package:mongo_dart/mongo_dart.dart';

class Post {
  final ObjectId id;
  final String image;
  final String descrition;
  final DateTime lastDate;
  final String userid;

  Post(
      {required this.id,
      required this.image,
      required this.descrition,
      required this.lastDate,
      required this.userid});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'image': image,
      'description': descrition,
      'lastDate': lastDate,
      'userid': userid,
    };
  }

  Post.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        image = map['image'],
        descrition = map['descrition'],
        lastDate = map['lastDate'],
        userid = map['userid'];
}
