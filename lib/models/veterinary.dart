import 'package:mongo_dart/mongo_dart.dart';

class Veterinary {
  final ObjectId id;
  final String consulta;
  final String fecha;
  final String lugar;
  final ObjectId idPerro;
  final String uid;

  Veterinary(
        {this.id, 
        this.consulta, 
        this.fecha, 
        this.lugar,
        this.idPerro,
        this.uid
        }
      );

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'consulta': consulta,
      'fecha': fecha,
      'lugar': lugar,
      'idPerro':idPerro,
      'uid': uid,
    };
  }

  Veterinary.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        consulta = map['consulta'],
        fecha = map['fecha'],
        lugar = map['lugar'],
        idPerro = map['idPerro'],
        uid = map['uid'];
}
