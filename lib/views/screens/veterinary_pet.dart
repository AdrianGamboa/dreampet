import 'package:flutter/material.dart';
import 'package:social_app_ui/models/veterinary.dart';
import 'package:social_app_ui/services/vaccineService.dart';
import 'package:social_app_ui/views/screens/add_vaccine.dart';
import 'package:social_app_ui/views/screens/add_veterinary.dart';
import '../../models/pet.dart';
import '../../models/vaccine.dart';
import '../../services/veterinaryService.dart';
import '../../util/const.dart';

IconData iconChoosed = Icons.sports_baseball;

class VeterinaryPet extends StatefulWidget {
  const VeterinaryPet({Key key, this.petInfo}) : super(key: key);
  final Pet petInfo;

  @override
  _VeterinaryPetState createState() => _VeterinaryPetState();
}

class _VeterinaryPetState extends State<VeterinaryPet> {
  List veterinaryList = [];
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
                "Registro de visitas al veterinario",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
              const SizedBox(height: 20),
              veterinaryFutureBuilder(
                  VeterinaryDB.getVeterinary(widget.petInfo.id), veterinaryList),
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
                    return AddVeterinaryPage(
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

  Widget veterinaryFutureBuilder(_future, list) => FutureBuilder(
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
              return buildVeterinaryCard(list);
            }
          }
        }
      });

  Widget buildVeterinaryCard(list) => ListView.separated(
        padding: EdgeInsets.all(10),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 0.5,
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(8.0),
              title: Container(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(width: 120, child: Text('Consulta: ')),
                          SizedBox(width: 120, child: Text(notif['consulta'])),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(width: 120, child: Text("Fecha: ")),
                          SizedBox(width: 120, child: Text(notif['fecha'])),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              )),
              subtitle: Container(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(width: 120, child: Text("Lugar: ")),
                          SizedBox(width: 120, child: Text(notif['lugar'])),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              )),
              trailing: Column(
                children: [
                  SizedBox(
                    height: 35,
                    child: IconButton(
                      iconSize: 20,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return AddVeterinaryPage(
                                petInfo: widget.petInfo,
                                veterinaryInfo: convertToVeterinary(notif),
                              );
                            },
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                        ;
                      },
                      icon: Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                  SizedBox(
                    child: IconButton(
                      onPressed: () {
                        VeterinaryDB.delete(convertToVeterinary(notif));
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.delete,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
  Veterinary convertToVeterinary(veterinary) {
    return Veterinary(
        id: veterinary['_id'],
        consulta: veterinary['consulta'],
        fecha: veterinary['fecha'],
        lugar: veterinary['lugar'],
        idPerro: veterinary['idPerro'],
        uid: veterinary['uid']);
  }
}
