import 'package:mongo_dart/mongo_dart.dart';
import '../database/mongodatabase.dart';
import '../models/post.dart';

class LostPostDB {
  static getDocuments() async {
    try {
      var response = [];
      final posts = await MongoDatabase.lostPostsCollection.find().toList();
      for (var item in posts) {
        final user = await MongoDatabase.usersCollection
            .findOne(where.eq("uid", item['userId']));
        response.add([item, user]);
      }
      return response;
    } catch (e) {
      return Future<List<Map<String, dynamic>>>.error(e);
    }
  }

  static insert(Post post) async {
    try {
      await MongoDatabase.lostPostsCollection.insertAll([post.toMap()]);
    } catch (e) {
      return Future.error(e);
    }
  }

  static update(Post post) async {
    try {
      var data =
          await MongoDatabase.lostPostsCollection.findOne({"_id": post.id});
      data["image"] = post.image;
      data["description"] = post.description;
      data["lastDate"] = post.publishedDate;

      await MongoDatabase.lostPostsCollection.save(data);
    } catch (e) {
      return Future.error(e);
    }
  }

  static delete(Post post) async {
    try {
      await MongoDatabase.lostPostsCollection.remove(where.id(post.id));
    } catch (e) {
      return Future.error(e);
    }
  }
}
