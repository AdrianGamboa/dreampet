import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../util/alerts.dart';
import '../util/global.dart';
import 'userService.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// registration with email and password

  Future createNewUser(String name, String lastName, String email,
      String password, BuildContext context) async {
    try {
      UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        UserDB.registerUser(name, lastName, email, value.user.uid.toString());
        return value;
      });
      User user = credential.user;
      userFire = user;
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          await showAlertDialog(context, '', 'El email ya está en uso');
          break;
        case 'invalid-email':
          await showAlertDialog(context, '', 'Email inválido');
          break;
        case 'operation-not-allowed':
          await showAlertDialog(context, '', 'Operación no permitida');
          break;
        case 'weak-password':
          await showAlertDialog(context, '', 'Contraseña débil');
          break;
        default:
          await showAlertDialog(context, '', 'Error desconocido');
          break;
      }
    }
  }

// sign with email and password

  Future loginUser(BuildContext context, String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = credential.user;
      userFire = user;
      return user;
    } on FirebaseAuthException catch (e) {
      String message = '';
      switch (e.code) {
        case 'user-not-found':
          message = 'Usuario no encontrado.';
          break;
        case 'invalid-email':
          message = 'El correo electrónico proporcionado es inválido.';
          break;
        case 'wrong-password':
          message = 'La contraseña no es válida.';
          break;
        case 'invalid-credential':
          message = 'Los credenciales proporcionados son inválidos.';
          break;
        case 'too-many-requests':
          message =
              'Hemos bloqueado todas las solicitudes de este dispositivo debido a que se detectó actividad inusual. Vuelva a intentarlo más tarde.';
          break;

        default:
          message = e.message;
      }
      showAlertDialog(context, 'Error', message);
    }
  }

// signout

  Future signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      userFire = null;
    } catch (e) {
      if (e == ("Internet error")) {
        showAlertDialog(context, 'Problema de conexión',
            'Comprueba si existe conexión a internet e inténtalo más tarde.');
      } else if (e == ('Email is not valid')) {
        showAlertDialog(context, 'Problema de datos',
            'El correo electrónico proporcionado es inválido.');
      } else {
        showAlertDialog(context, 'Problema con el servidor',
            'Es posible que alguno de los servicios no esté funcionando correctamente. Recomendamos que vuelva a intentarlo más tarde.');
      }
      return Future.error(e);
    }
  }
}
