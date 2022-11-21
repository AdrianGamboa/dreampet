import 'package:mongo_dart/mongo_dart.dart';

class Pet {
  final ObjectId id;
  final String nombre;
  final int edad;
  final int peso;
  final int icon;
  final int color;
  final String uid;

  Pet(
        {this.id, 
        this.nombre, 
        this.edad, 
        this.peso, 
        this.icon,
        this.color,
        this.uid
        }
      );

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'nombre': nombre,
      'edad': edad,
      'peso': peso,
      'icon': icon,
      'color': color,
      'uid': uid,
    };
  }

  Pet.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        nombre = map['nombre'],
        edad = map['edad'],
        peso = map['peso'],
        icon = map['icon'],
        color = map['color'],
        uid = map['uid'];
}
