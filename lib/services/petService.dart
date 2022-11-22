import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:social_app_ui/models/pet.dart';
import '../util/global.dart';
import '../database/mongodatabase.dart';
class petDB{
  static getMyPets() async {
    try {
      final pets = await MongoDatabase.petsCollection
          .find(m.where.eq("uid", userFire.uid.toString())).toList();
      print(pets);
      return pets;
    } catch (e) {
      return Future<Map<String, dynamic>>.error(e);
    }
  }

  static insert(Pet pet) async {
    try {
      await MongoDatabase.petsCollection.insertAll([pet.toMap()]);
    } catch (e) {
      return Future.error(e);
    }
  }

  static update(Pet pet) async {
    try {
      var data = await MongoDatabase.petsCollection.findOne({"_id": pet.id});
      data["nombre"] = pet.nombre;
      data["edad"] = pet.edad;
      data["peso"] = pet.peso;
      data["icon"] = pet.icon;
      data["color"] = pet.color;
      await MongoDatabase.petsCollection.save(data);
    } catch (e) {
      return Future.error(e);
    }
  }

  static delete(Pet pet) async {
    try {
      await MongoDatabase.petsCollection.remove(where.id(pet.id));
    } catch (e) {
      return Future.error(e);
    }
  }
}
