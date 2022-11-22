import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:social_app_ui/models/vaccine.dart';
import '../util/global.dart';
import '../database/mongodatabase.dart';
class VaccineDB{

  static getVaccines(ObjectId petId) async {
    try {
      final vaccines = await MongoDatabase.vaccinesCollection
          .find(m.where.eq("idPerro", petId)).toList();
      print(vaccines);
      return vaccines;
    } catch (e) {
      return Future<Map<String, dynamic>>.error(e);
    }
  }

  static insert(Vaccine vaccine) async {
    try {
      await MongoDatabase.vaccinesCollection.insertAll([vaccine.toMap()]);
    } catch (e) {
      return Future.error(e);
    }
  }

  static update(Vaccine vaccine) async {
    try {
      var data = await MongoDatabase.vaccinesCollection.findOne({"_id": vaccine.id});
      data["nombre"] = vaccine.nombre;
      data["fecha"] = vaccine.fecha;
      data["descripcion"] = vaccine.descripcion;
      data["lugar"] = vaccine.lugar;
      await MongoDatabase.vaccinesCollection.save(data);
    } catch (e) {
      return Future.error(e);
    }
  }

  static delete(Vaccine vaccine) async {
    try {
      await MongoDatabase.vaccinesCollection.remove(where.id(vaccine.id));
    } catch (e) {
      return Future.error(e);
    }
  }
}
