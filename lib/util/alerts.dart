import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:social_app_ui/models/vaccine.dart';
import 'package:social_app_ui/services/petService.dart';
import 'package:social_app_ui/services/vaccineService.dart';

import '../models/pet.dart';

showAlertDialog(BuildContext context, String header, String message) {
  // Create button
  Widget okButton = TextButton(
    style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
    onPressed: () {
      Navigator.of(context).pop();
    },
    child: const Text("OK"),
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(header),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

AlertDeletePet(BuildContext context, String header, String message, Pet pet) {
  // Create button
  Widget okButton = TextButton(
    onPressed: () async {
      try {
      await petDB.delete(pet);
    } catch (e) {
      if (e == ("Internet error")) {
        showAlertDialog(context, 'Problema de conexión',
            'Comprueba si existe conexión a internet e inténtalo más tarde.');
      } else {
        showAlertDialog(context, 'Problema con el servidor',
            'Es posible que alguno de los servicios no esté funcionando correctamente. Recomendamos que vuelva a intentarlo más tarde.');
      }
      return Future.error(e);
    }
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    },
    child: const Text("Sí"),
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(header),
    content: Text(message),
    actions: [
      TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

AlertDeleteVaccine(BuildContext context, String header, String message, Vaccine vaccine) {
  // Create button
  Widget okButton = TextButton(
    onPressed: () async {
      try {
      await VaccineDB.delete(vaccine);
    } catch (e) {
      if (e == ("Internet error")) {
        showAlertDialog(context, 'Problema de conexión',
            'Comprueba si existe conexión a internet e inténtalo más tarde.');
      } else {
        showAlertDialog(context, 'Problema con el servidor',
            'Es posible que alguno de los servicios no esté funcionando correctamente. Recomendamos que vuelva a intentarlo más tarde.');
      }
      return Future.error(e);
    }
      Navigator.of(context).pop();
    },
    child: const Text("Sí"),
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(header),
    content: Text(message),
    actions: [
      TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
