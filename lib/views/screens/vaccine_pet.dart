import 'package:flutter/material.dart';
import 'package:social_app_ui/services/vaccineService.dart';
import 'package:social_app_ui/views/screens/add_vaccine.dart';
import '../../models/pet.dart';
import '../../models/vaccine.dart';
import '../../util/const.dart';

IconData iconChoosed = Icons.sports_baseball;

class VaccinesPet extends StatefulWidget {
  const VaccinesPet({Key key, this.petInfo}) : super(key: key);
  final Pet petInfo;

  @override
  _VaccinesPetState createState() => _VaccinesPetState();
}

class _VaccinesPetState extends State<VaccinesPet> {
  List vaccinesList = [];
  bool updatePets = false;
  refresh() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (updatePets) {
          Navigator.pop(context, true);
        } else {
          Navigator.pop(context, false);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Container(
              margin: EdgeInsets.only(top: 15, bottom: 10),
              child:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Image.asset(
                          '${Constants.logoWhite}',
                          height: 120,
                        )
                      : Image.asset(
                          '${Constants.logoBlack}',
                          height: 120,
                        )),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                "Registro de vacunas",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
              const SizedBox(height: 20),
              vaccinesFutureBuilder(
                  VaccineDB.getVaccines(widget.petInfo.id), vaccinesList),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          height: 50,
          width: 50,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AddVaccinePage(
                      petInfo: widget.petInfo,
                    );
                  }).then((value) {
                if (value) {
                  updatePets = true;
                  setState(() {});
                }
              });
            },
            child: const Text(
              "+",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget vaccinesFutureBuilder(_future, list) => FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator
          return Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator()));
        } else {
          if (snapshot.hasError) {
            // Return error
            return const Center(child: Text('Error al extraer la información'));
          } else {
            list = snapshot.data as List;
            if (list.isEmpty) {
              return const Center(child: Text('Sin información disponible'));
            } else {
              return buildVaccineCard(list);
            }
          }
        }
      });

  Widget buildVaccineCard(list) => ListView.separated(
        padding: EdgeInsets.all(10),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 25,
              width: MediaQuery.of(context).size.width / 1.3,
              child: Divider(
                height: 3,
              ),
            ),
          );
        },
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          Map notif = list[index];
          return ListTile(                
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Column(
                            children: [
                              SizedBox(width: 120, child: Text('Nombre: ')),
                              SizedBox(
                                  width: 120, child: Text(notif['nombre'])),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(width: 120, child: Text("Fecha: ")),
                            SizedBox(width: 120, child: Text(notif['fecha'])),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Column(
                            children: [
                              SizedBox(
                                  width: 120, child: Text('Descripción: ')),
                              SizedBox(
                                  width: 120,
                                  child: Text(notif['descripcion'])),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(width: 120, child: Text("Lugar: ")),
                            SizedBox(width: 120, child: Text(notif['lugar'])),
                          ],
                        )
                      ],
                    )
                  ]),
                  Column(
                    children: [
                      SizedBox(
                        height: 35,
                        child: IconButton(
                          iconSize: 20,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return AddVaccinePage(
                                    petInfo: widget.petInfo,
                                    vaccineInfo: convertToVaccine(notif),
                                  );
                                },
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: IconButton(
                          onPressed: () {
                            VaccineDB.delete(convertToVaccine(notif));
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.delete,
                          ),
                        ),
                      ),
                    ],
                  ),                  
                ],
              ),
              trailing: SizedBox());
        },
      );
  Vaccine convertToVaccine(vaccine) {
    return Vaccine(
        id: vaccine['_id'],
        nombre: vaccine['nombre'],
        fecha: vaccine['fecha'],
        descripcion: vaccine['descripcion'],
        lugar: vaccine['lugar'],
        idPerro: vaccine['idPerro'],
        uid: vaccine['uid']);
  }
}
