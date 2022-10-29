import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database/mongodatabase.dart';
import 'app.dart';

void main() async {
  await MongoDatabase.connect();
  runApp(MyApp());
}
