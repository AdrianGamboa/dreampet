import 'package:mongo_dart/mongo_dart.dart';
import '../database/mongodatabase.dart';
import '../models/post.dart';

class PostDB {
  static Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      final posts = await MongoDatabase.postsCollection.find().toList();
      return posts;
    } catch (e) {
      return Future<List<Map<String, dynamic>>>.error(e);
    }
  }

  static insert(Post post) async {
    try {
      await MongoDatabase.postsCollection.insertAll([post.toMap()]);
    } catch (e) {
      return Future.error(e);
    }
  }

  static update(Post post) async {
    try {
      var data = await MongoDatabase.postsCollection.findOne({"_id": post.id});
      data["image"] = post.image;
      data["description"] = post.descrition;
      data["lastDate"] = post.lastDate;

      await MongoDatabase.postsCollection.save(data);
    } catch (e) {
      return Future.error(e);
    }
  }

  static delete(Post post) async {
    try {
      await MongoDatabase.postsCollection.remove(where.id(post.id));
    } catch (e) {
      return Future.error(e);
    }
  }
}
