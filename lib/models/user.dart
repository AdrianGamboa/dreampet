import 'package:mongo_dart/mongo_dart.dart';

class User {
  final ObjectId id;
  final String name;
  final String lastName;
  final String email;
  final String phone;
  final String avatarURL;
  final String uid;

  User(
      {this.id,
      this.name,
      this.lastName,
      this.email,
      this.phone,
      this.avatarURL,
      this.uid});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'avatarURL': avatarURL,
      'uid': uid,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        id = map['_id'],
        lastName = map['lastName'],
        email = map['email'],
        phone = map['phone'],
        avatarURL = map['avatarURL'],
        uid = map['uid'];
}
