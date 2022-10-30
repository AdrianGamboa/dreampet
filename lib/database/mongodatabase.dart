import 'package:mongo_dart/mongo_dart.dart';
import '../util/global.dart';

class MongoDatabase {
  static var db, usersCollection, adoptionPostsCollection, lostPostsCollection;

  static connect() async {
    db = await Db.create(mongoConnUrl);
    await db.open();
    usersCollection = db.collection('users');
    adoptionPostsCollection = db.collection("adoptionPosts");
    lostPostsCollection = db.collection("lostPosts");
  }
}
