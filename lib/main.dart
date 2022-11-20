import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/firebase.dart';
import 'database/mongodatabase.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  await FireDatabase.initializeFirebase();

  //Verifica si hay que mostrar la introducción inicial
  final prefs = await SharedPreferences.getInstance();
  final showIntroduction = prefs.getBool('showIntroduction') ?? false;
  runApp(MyApp(showIntroduction: showIntroduction));
}
