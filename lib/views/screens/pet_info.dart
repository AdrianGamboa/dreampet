import 'package:flutter/material.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/views/screens/veterinary_pet.dart';

import '../../models/pet.dart';
import '../../util/alerts.dart';
import '../../util/const.dart';
import 'add_pet.dart';
import 'vaccine_pet.dart';

class PetsInfo extends StatefulWidget {
  const PetsInfo({Key key, this.petInfo}) : super(key: key);

  final Pet petInfo;

  @override
  _PetsInfoState createState() => _PetsInfoState();
}

class _PetsInfoState extends State<PetsInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Container(
            margin: EdgeInsets.only(top: 15, bottom: 10),
            child: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Image.asset(
                    '${Constants.logoWhite}',
                    height: 120,
                  )
                : Image.asset(
                    '${Constants.logoBlack}',
                    height: 120,
                  )),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<int>(
            tooltip: 'Acciones',
            itemBuilder: (context) => [
              // # 1
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Text("Editar información",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline6.color))
                  ],
                ),
              ),
              // # 4
              PopupMenuItem(
                value: 4,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Text("Eliminar mascota",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline6.color))
                  ],
                ),
              ),
            ],
            color: Theme.of(context).primaryColor,
            elevation: 2,
            onSelected: (value) async {
              if (value == 1) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return AddPetPage(petInfo: widget.petInfo);
                    },
                  ),
                ).then((value) => Navigator.pop(context));
              } else if (value == 4) {
                 AlertDeletePet(context,"Eliminar mascota","¿Desea borrar esta mascota?",widget.petInfo);
              }
              ;
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 160.0),
              child: Center(
                  child: Text(
                widget.petInfo.nombre,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
              )),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/perro.png',
                    height: 40.0,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Edad: " + widget.petInfo.edad.toString()+" años",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/perro_peso.png',
                    height: 40.0,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Peso: " + widget.petInfo.peso.toString()+" kilos",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/perro_vacuna.png',
                    height: 40.0,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Vacunas: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
            TextButton(onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return VaccinesPet(petInfo: widget.petInfo);
                    },
                  ),
                );}, child: Text("Ver registro completo")),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/veterinario.png',
                    height: 40.0,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Visita al veterinario: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
            TextButton(onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return VeterinaryPet(petInfo: widget.petInfo);
                    },
                  ),
                );
            }, child: Text("Ver registro completo"))
          ],
        ),
      ),
    );
  }

  Pet convertToPet(pet_) {
    return Pet(
        id: pet_['_id'],
        nombre: pet_['nombre'],
        edad: pet_['edad'],
        peso: pet_['peso'],
        icon: pet_['icon'],
        color: pet_['color'],
        uid: pet_['uid']);
  }
}
