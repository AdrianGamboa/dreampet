import 'package:mongo_dart/mongo_dart.dart';
import '../util/global.dart';

class MongoDatabase {
  static var db, usersCollection, postsCollection;

  static connect() async {
    db = await Db.create(mongoConnUrl);
    await db.open();
    usersCollection = db.collection('users');
    postsCollection = db.collection("posts");
  }
}
