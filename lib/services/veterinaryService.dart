import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:social_app_ui/models/vaccine.dart';
import 'package:social_app_ui/models/veterinary.dart';
import '../util/global.dart';
import '../database/mongodatabase.dart';
class VeterinaryDB{

  static getVeterinary(ObjectId petId) async {
    try {
      final veterinary = await MongoDatabase.veterinaryCollection
          .find(m.where.eq("idPerro", petId)).toList();
      return veterinary;
    } catch (e) {
      return Future<Map<String, dynamic>>.error(e);
    }
  }

  static insert(Veterinary veterinary) async {
    try {
      await MongoDatabase.veterinaryCollection.insertAll([veterinary.toMap()]);
    } catch (e) {
      return Future.error(e);
    }
  }

  static update(Veterinary veterinary) async {
    try {
      var data = await MongoDatabase.veterinaryCollection.findOne({"_id": veterinary.id});
      data["consulta"] = veterinary.consulta;
      data["fecha"] = veterinary.fecha;
      data["lugar"] = veterinary.lugar;
      await MongoDatabase.veterinaryCollection.save(data);
    } catch (e) {
      return Future.error(e);
    }
  }

  static delete(Veterinary veterinary) async {
    try {
      await MongoDatabase.veterinaryCollection.remove(where.id(veterinary.id));
    } catch (e) {
      return Future.error(e);
    }
  }
}
