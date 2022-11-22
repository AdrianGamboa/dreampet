import 'package:mongo_dart/mongo_dart.dart';

class Vaccine {
  final ObjectId id;
  final String nombre;
  final String fecha;
  final String descripcion;
  final String lugar;
  final ObjectId idPerro;
  final String uid;

  Vaccine(
        {this.id, 
        this.nombre, 
        this.fecha, 
        this.descripcion, 
        this.lugar,
        this.idPerro,
        this.uid
        }
      );

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'nombre': nombre,
      'fecha': fecha,
      'descripcion': descripcion,
      'lugar': lugar,
      'idPerro':idPerro,
      'uid': uid,
    };
  }

  Vaccine.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        nombre = map['nombre'],
        fecha = map['fecha'],
        descripcion = map['descripcion'],
        lugar = map['lugar'],
        idPerro = map['idPerro'],
        uid = map['uid'];
}
