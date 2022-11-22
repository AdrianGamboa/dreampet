import 'package:flutter/material.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/views/screens/add_pet.dart';
import 'package:social_app_ui/views/screens/pet_info.dart';
import '../../models/pet.dart';
import '../../services/petService.dart';
import '../../util/const.dart';

IconData iconChoosed = Icons.sports_baseball;

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List myPetsList = [];
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
                "Mis Mascotas",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
              myPetsFutureBuilder(petDB.getMyPets(), myPetsList),
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
                    return AddPetPage();
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

  Widget myPetsFutureBuilder(_future, list) => FutureBuilder(
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
              return buildMyPetCard(list);
            }
          }
        }
      });

  Widget buildMyPetCard(list) => ListView.separated(
        padding: EdgeInsets.all(10),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width / 1.3,
              child: Divider(),
            ),
          );
        },
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          Map notif = list[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(
                  IconData(notif['icon'], fontFamily: 'MaterialIcons'),
                  color: Color(notif['color'])),
              contentPadding: EdgeInsets.all(0),
              title: Text(notif['nombre']),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PetsInfo(petInfo: convertToPet(notif),
                      );
                    },
                  ),
                ).then((value) => setState(() {}));
              },
            ),
          );
        },
      );
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

class IconPicker extends StatefulWidget {
  static List<IconData> icons = [
    Icons.sports_baseball,
    Icons.sports_basketball_outlined,
    Icons.sports_football_outlined,
    Icons.sports_soccer_rounded,
    Icons.sports_volleyball_outlined,
    Icons.star_border,
    Icons.stars,
    Icons.smart_toy_outlined,
    Icons.tag_faces,
    Icons.videogame_asset_rounded,
    Icons.weekend_rounded,
    Icons.whatshot,
    Icons.workspace_premium,
    Icons.yard,
    Icons.agriculture,
    Icons.anchor,
    Icons.auto_fix_normal,
    Icons.bedroom_baby,
    Icons.catching_pokemon,
    Icons.celebration,
  ];

  const IconPicker({Key key}) : super(key: key);

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Seleccione un icono:"),
        const SizedBox(height: 5),
        Wrap(
          spacing: 5,
          children: <Widget>[
            for (var icon in IconPicker.icons)
              GestureDetector(
                onTap: () {
                  setState(() {
                    iconChoosed = icon;
                  });
                },
                child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3.0)),
                        border: Border.all(
                            color: iconChoosed == icon
                                ? Colors.blueAccent
                                : Colors.transparent)),
                    child: Icon(icon, size: 30)),
              )
          ],
        ),
      ],
    );
  }
}
