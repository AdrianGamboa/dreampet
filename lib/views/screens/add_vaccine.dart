import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:social_app_ui/models/vaccine.dart';
import 'package:social_app_ui/services/vaccineService.dart';
import '../../models/pet.dart';
import '../../util/alerts.dart';
import '../../util/global.dart';

class AddVaccinePage extends StatefulWidget {
  const AddVaccinePage({Key key, this.vaccineInfo, this.petInfo})
      : super(key: key);

  final Vaccine vaccineInfo;
  final Pet petInfo;

  @override
  State<AddVaccinePage> createState() => _AddVaccinePageState();
}

class _AddVaccinePageState extends State<AddVaccinePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nombreTextController = TextEditingController();
  final descripcionTextController = TextEditingController();
  final lugarTextController = TextEditingController();
  final fechaTextController = TextEditingController();
  DateTime pickedDate;

  bool update = false;

  @override
  void initState() {
    super.initState();
    initTaskInfo();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
      child: AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancelar")),
            TextButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    if (update) {
                      updateVaccine()
                          .then((value) => Navigator.of(context).pop(true))
                          .onError((error, stackTrace) => null);
                    } else {
                      insertVacinne()
                          .then((value) => Navigator.of(context).pop(true))
                          .onError((error, stackTrace) => null);
                    }
                  }
                },
                child: const Text("Guardar"))
          ],
          content: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 380,
                  child: dialogContent()))),
    );
  }

  Widget dialogContent() {
    return Column(children: [
      !update
          ? const Text("Agregar Vacuna",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20))
          : const Text("Modificar Vacuna",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
      const SizedBox(height: 20),
      Form(
          key: _formKey,
          child: Column(
            children: [
              textForm('Nombre', 1, 18, nombreTextController, false, true),
              const SizedBox(height: 20),
              datePick(),
              const SizedBox(height: 20),
              textForm('Descripción', 3, 300, descripcionTextController, false,
                  true),
              const SizedBox(height: 20),
              textForm('Lugar', 1, 30, lugarTextController, false, true),
            ],
          )),
      const SizedBox(height: 30),
      const SizedBox(height: 20),
      const SizedBox(height: 20),
    ]);
  }

  Widget textForm(name, lines, lenght, controller, numKeyboard, band) {
    return SizedBox(
        width: 320,
        child: TextFormField(
            inputFormatters:
                numKeyboard ? [FilteringTextInputFormatter.digitsOnly] : null,
            keyboardType:
                numKeyboard ? TextInputType.number : TextInputType.text,
            maxLength: lenght,
            maxLines: lines,
            minLines: 1,
            controller: controller,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (band == true) {
                if (nombreTextController.text == '') return 'Ingrese un nombre';
              } else if (band == false) {
                if (descripcionTextController.text == '')
                  return 'Ingrese una descripción';
                if (lugarTextController.text == '')
                  return 'Ingrese un lugar de vacunación';
              }
              return null;
            },
            decoration: InputDecoration(
              counterText: "",
              suffixIcon: IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  iconSize: 18,
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    controller.clear();
                  },
                  icon: const Icon(Icons.clear)),
              labelText: name,
            )));
  }

  Widget datePick() {
    return TextFormField(
        controller: fechaTextController, //editing controller of this TextField
        decoration: const InputDecoration(
            icon: Icon(Icons.calendar_today), //icon of text field
            labelText: "Ingresar fecha" //label text of field
            ),
        validator: (value) {
          if (pickedDate == null) {
            return 'Ingrese una fecha';
          }
          return null;
        },
        onTap: () async {
          pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(), //get today's date
              firstDate: DateTime(
                  2000), //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2101));

          if (pickedDate != null) { 
            String formattedDate = DateFormat('yyyy-MM-dd').format(
                pickedDate); 
            setState(() {
              fechaTextController.text =
                  formattedDate; 
            });
          } else {
            print("Date is not selected");
          }
        });
  }

  initTaskInfo() {
    if (widget.vaccineInfo != null) {
      nombreTextController.text = widget.vaccineInfo.nombre;
      pickedDate= DateTime.parse(widget.vaccineInfo.fecha);
      fechaTextController.text = widget.vaccineInfo.fecha;
      descripcionTextController.text = widget.vaccineInfo.descripcion;
      lugarTextController.text = widget.vaccineInfo.lugar;
      update = true;
    }
  }

  clearTxt() {
    FocusScope.of(context).requestFocus(FocusNode());
    nombreTextController.clear();
    fechaTextController.clear();
    descripcionTextController.clear();
    lugarTextController.clear();
  }

  Future insertVacinne() async {
    try {
      await VaccineDB.insert(Vaccine(
          id: m.ObjectId(),
          nombre: nombreTextController.text,
          fecha: fechaTextController.text,
          descripcion: descripcionTextController.text,
          lugar: lugarTextController.text,
          idPerro: widget.petInfo.id,
          uid: userFire.uid.toString()));
    } catch (e) {
      if (e == ("Internet error")) {
        showAlertDialog(context, 'Problema de conexión',
            'Comprueba si existe conexión a internet e inténtalo más tarde.');
      } else {
        showAlertDialog(context, 'Problema con el servidor',
            'Es posible que alguno de los servicios no esté funcionando correctamente. Recomendamos que vuelva a intentarlo más tarde.');
      }
      setState(() {});
      return Future.error(e);
    }
  }

  Future updateVaccine() async {
    try {
      await VaccineDB.update(Vaccine(
          id: widget.vaccineInfo.id,
          nombre: nombreTextController.text,
          fecha: fechaTextController.text,
          descripcion: descripcionTextController.text,
          lugar: lugarTextController.text,
          idPerro: widget.vaccineInfo.id,
          uid: widget.vaccineInfo.uid));
    } catch (e) {
      if (e == ("Internet error")) {
        showAlertDialog(context, 'Problema de conexión',
            'Comprueba si existe conexión a internet e inténtalo más tarde.');
      } else {
        showAlertDialog(context, 'Problema con el servidor',
            'Es posible que alguno de los servicios no esté funcionando correctamente. Recomendamos que vuelva a intentarlo más tarde.');
      }
      setState(() {});
      return Future.error(e);
    }
  }
}
