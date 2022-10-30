import 'package:mongo_dart/mongo_dart.dart';

class User {
  final ObjectId id;
  final String name;
  final String lastName;
  final String email;

  final String uid;

  User({this.id, this.name, this.lastName, this.email, this.uid});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'lastName': lastName,
      'email': email,
      'uid': uid,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        id = map['_id'],
        lastName = map['lastName'],
        email = map['email'],
        uid = map['uid'];
}
