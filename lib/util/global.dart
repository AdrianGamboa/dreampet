import 'package:firebase_auth/firebase_auth.dart' as a;
import 'package:firebase_auth/firebase_auth.dart';

const mongoConnUrl =
    "mongodb+srv://mosqueteros:nbVLSNOpgKzWof20@cluster0.ljxf7d2.mongodb.net/dreampet";

FirebaseAuth authFire = FirebaseAuth.instance;
a.User userFire; // User of the session

const defaultAvatarURL =
    "https://firebasestorage.googleapis.com/v0/b/dreampet-f703a.appspot.com/o/users%2Fprofile.jpeg?alt=media&token=b59d4eef-8bf4-407a-8f9d-154138aa2199";
