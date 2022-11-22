import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:social_app_ui/models/vaccine.dart';
import 'package:social_app_ui/models/veterinary.dart';
import 'package:social_app_ui/services/vaccineService.dart';
import 'package:social_app_ui/services/veterinaryService.dart';
import '../../models/pet.dart';
import '../../util/alerts.dart';
import '../../util/global.dart';

class AddVeterinaryPage extends StatefulWidget {
  const AddVeterinaryPage({Key key, this.veterinaryInfo, this.petInfo})
      : super(key: key);

  final Veterinary veterinaryInfo;
  final Pet petInfo;

  @override
  State<AddVeterinaryPage> createState() => _AddVeterinaryPageState();
}

class _AddVeterinaryPageState extends State<AddVeterinaryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final consultaTextController = TextEditingController();
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
                      updateVeterinary()
                          .then((value) => Navigator.of(context).pop(true))
                          .onError((error, stackTrace) => null);
                    } else {
                      insertVeterinary()
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
          ? const Text("Agregar visita al veterinario",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20))
          : const Text("Modificar visita al veterinario",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
      const SizedBox(height: 20),
      Form(
          key: _formKey,
          child: Column(
            children: [
              textForm('Consulta', 3, 300, consultaTextController, false,true),
              const SizedBox(height: 20),
              datePick(),
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
                if (consultaTextController.text == '') return 'Ingrese un nombre';
                if (lugarTextController.text == '')
                  return 'Ingrese un lugar de vacunación';
              } else if (band == false) {
               
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
    if (widget.veterinaryInfo != null) {
      consultaTextController.text = widget.veterinaryInfo.consulta;
      pickedDate= DateTime.parse(widget.veterinaryInfo.fecha);
      fechaTextController.text = widget.veterinaryInfo.fecha;
      lugarTextController.text = widget.veterinaryInfo.lugar;
      update = true;
    }
  }

  clearTxt() {
    FocusScope.of(context).requestFocus(FocusNode());
    consultaTextController.clear();
    fechaTextController.clear();
    lugarTextController.clear();
  }

  Future insertVeterinary() async {
    try {
      await VeterinaryDB.insert(Veterinary(
          id: m.ObjectId(),
          consulta: consultaTextController.text,
          fecha: fechaTextController.text,
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

  Future updateVeterinary() async {
    try {
      await VeterinaryDB.update(Veterinary(
          id: widget.veterinaryInfo.id,
          consulta: consultaTextController.text,
          fecha: fechaTextController.text,
          lugar: lugarTextController.text,
          idPerro: widget.veterinaryInfo.id,
          uid: widget.veterinaryInfo.uid));
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
