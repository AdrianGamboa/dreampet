import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database/firebase.dart';
import 'database/mongodatabase.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  await FireDatabase.initializeFirebase();
  runApp(MyApp());
}
