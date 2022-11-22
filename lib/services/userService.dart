import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import '../util/global.dart';
import '../database/mongodatabase.dart';
import '../models/user.dart';

class UserDB {
  static Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      final users = await MongoDatabase.usersCollection.find().toList();
      return users;
    } catch (e) {
      return Future<List<Map<String, dynamic>>>.error(e);
    }
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final users = await MongoDatabase.usersCollection
          .findOne(m.where.eq("uid", userFire.uid.toString()));
      return users;
    } catch (e) {
      return Future<Map<String, dynamic>>.error(e);
    }
  }

  static insert(User user) async {
    try {
      await MongoDatabase.usersCollection.insertAll([user.toMap()]);
    } catch (e) {
      return Future.error(e);
    }
  }

  static update(User user) async {
    try {
      var u = await MongoDatabase.usersCollection.findOne({"_id": user.id});
      u["name"] = user.name;
      u["lastName"] = user.lastName;
      u["email"] = user.email;
      u["avatarURL"] = user.avatarURL;
      u["uid"] = user.uid;
      await MongoDatabase.usersCollection.save(u);
    } catch (e) {
      return Future.error(e);
    }
  }

  static delete(User user) async {
    try {
      await MongoDatabase.usersCollection.remove(where.id(user.id));
    } catch (e) {
      return Future.error(e);
    }
  }

  static registerUser(name, lastName, email, phone, uid) async {
    try {
      final user = User(
          id: m.ObjectId(),
          name: name,
          lastName: lastName,
          email: email,
          phone: phone,
          avatarURL: defaultAvatarURL,
          uid: uid);
      await insert(user);
    } catch (e) {
      return Future.error(e);
    }
  }
}
