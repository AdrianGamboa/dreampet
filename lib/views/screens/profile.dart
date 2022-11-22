import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app_ui/views/screens/auth/login.dart';
import '../../models/user.dart';
import '../../services/AuthenticationService.dart';
import '../../services/userService.dart';
import '../../util/alerts.dart';
import '../../util/connection.dart';
import '../../util/const.dart';
import '../../util/router.dart';
import 'introduction_screen.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<Map<String, dynamic>> getUser;
  User user;
  File _imageFile;
  bool _loadindicador = false;
  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_loadindicador,
      child: IgnorePointer(
        ignoring: _loadindicador,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Container(
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  child: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
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
                PopupMenuButton<String>(
                  onSelected: handleClick,
                  icon: Icon(
                    Icons.filter_list,
                  ),
                  itemBuilder: (BuildContext context) {
                    return {'Prólogo', 'Cerrar sesión'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            body: _loadindicador
                ? LinearProgressIndicator()
                : SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 150),
                    child: ReRunnableFutureBuilder(getUser,
                        getUserInformation: getUserInformation),
                  ),
          ),
        ),
      ),
    );
  }

  _getUser() async {
    try {
      setState(() {
        getUser = UserDB.getCurrentUser();
      });
      dynamic u = await getUser;
      user = User.fromMap(u);
    } catch (e) {}
  }

  List<Widget> getUserInformation(data, context) {
    List<Widget> userData = [];
    userData.add(Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(alignment: Alignment.topCenter, children: [
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Card(            
            elevation: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50),
                Container(
                  width: 300,
                  margin: const EdgeInsets.only(top: 20),
                  child: AutoSizeText(data['name'] + ' ' + data['lastName'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: 300,
                  margin: const EdgeInsets.only(top: 15),
                  child: AutoSizeText(data['email'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.headline6.color,
                          fontWeight: FontWeight.w500)),
                ),
                Container(
                  width: 300,
                  margin: const EdgeInsets.only(top: 5),
                  child: AutoSizeText('Teléfono: ' + data['phone'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.headline6.color,
                          fontWeight: FontWeight.w500)),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      AuthenticationService()
                          .signOut(context)
                          .then((value) =>
                              Navigate.pushPageReplacement(context, Login()))
                          .onError((error, stackTrace) => setState(() {}));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.logout),
                        SizedBox(width: 5),
                        Text('Cerrar Sesión',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: GestureDetector(
            onTap: () => _getFromGallery(),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data['avatarURL']),
              radius: 50,
            ),
          ),
        ),
      ]),
    ));

    return userData;
  }

  /// Get from gallery
  _getFromGallery() async {
    XFile pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 15,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        updateUser();
      });
    }
  }

  Future<String> _uploadToFirebase(String pathName) async {
    if (_imageFile != null) {
      try {
        if (await hasNetwork()) {
          final uploadTask =
              FirebaseStorage.instance.ref().child('users/$pathName');

          await uploadTask.putFile(_imageFile);
          String url = await uploadTask.getDownloadURL();
          return url;
        } else {
          throw ('Internet error');
        }
      } catch (e) {
        return Future.error(e);
      }
    }
    return null;
  }

  updateUser() async {
    try {
      _loadindicador = true;
      final userObject = User(
          id: user.id,
          name: user.name,
          lastName: user.lastName,
          email: user.email,
          phone: user.phone,
          avatarURL: await _uploadToFirebase(user.id.$oid),
          uid: user.uid);

      await UserDB.update(userObject);
      _loadindicador = false;
      await _getUser();
    } catch (e) {
      _loadindicador = false;
      if (e == ("Internet error")) {
        showAlertDialog(context, 'Problema de conexión',
            'Compruebe si existe conexión a internet e inténtale más tarde.');
      } else {
        showAlertDialog(context, 'Problema con el servidor',
            'Es posible que alguno de los servicios no esté funcionando correctamente. Recomendamos que vuelva a intentarlo más tarde.');
      }
      setState(() {});
    }
  }

  void handleClick(String value) {
    switch (value) {
      case 'Prólogo':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => IntroductionScreenPage(intro: false)));
        break;
      case 'Cerrar sesión':
        AuthenticationService()
            .signOut(context)
            .then((value) => Navigate.pushPageReplacement(context, Login()))
            .onError((error, stackTrace) => setState(() {}));
        break;
    }
  }
}

class ReRunnableFutureBuilder extends StatelessWidget {
  final Future<Map<String, dynamic>> _future;

  const ReRunnableFutureBuilder(this._future,
      {Key key, this.getUserInformation})
      : super(key: key);

  final Function getUserInformation;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return const Text("Error al extraer la información");
          }

          return Column(
            children: getUserInformation(snapshot.data, context),
          );
        });
  }
}
