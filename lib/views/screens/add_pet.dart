import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:social_app_ui/services/petService.dart';
import '../../models/pet.dart';
import '../../util/alerts.dart';
import '../../util/global.dart';

IconData iconChoosed = Icons.sports_baseball;

class AddPetPage extends StatefulWidget {
  const AddPetPage({Key key, this.petInfo}) : super(key: key);

  final Pet petInfo;

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  Color _tempShadeColor;
  Color _shadeColor = Colors.orange[100];
  Color _tempMainColor;
  Color _mainColor = Colors.orange;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nombreTextController = TextEditingController();
  final edadTextController = TextEditingController();
  final pesoTextController = TextEditingController();

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
                      updatePet()
                          .then((value) => Navigator.of(context).pop(true))
                          .onError((error, stackTrace) => null);
                    } else {
                      insertPet()
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
          ? const Text("Agregar Mascota",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20))
          : const Text("Modificar Mascota",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
      const SizedBox(height: 20),
      Form(
          key: _formKey,
          child: Column(
            children: [
              textForm('Nombre', 1, 18, nombreTextController, false, true),
              const SizedBox(height: 20),
              textForm('Edad en años', 1, 10, edadTextController, true, false),
              const SizedBox(height: 20),
              textForm('Peso en kilogramos', 1, 10, pesoTextController, true, false),
            ],
          )),
      const SizedBox(height: 30),
      const IconPicker(),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Seleccione un color: "),
          IconButton(
            splashRadius: 25,
            iconSize: 35,
            icon: Icon(
              Icons.circle,
              color: _shadeColor,
            ),
            onPressed: () {
              _openColorPicker();
            },
          ),
        ],
      ),
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
                if (edadTextController.text == '') return 'Ingrese una edad';
                if (pesoTextController.text == '') return 'Ingrese un peso';
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

  initTaskInfo() {
    if (widget.petInfo != null) {
      nombreTextController.text = widget.petInfo.nombre;
      edadTextController.text = widget.petInfo.edad.toString();
      pesoTextController.text = widget.petInfo.peso.toString();
      iconChoosed =
          IconData(widget.petInfo.icon, fontFamily: 'MaterialIcons');
      _shadeColor = Color(widget.petInfo.color);
      update = true;
    }
  }

  clearTxt() {
    FocusScope.of(context).requestFocus(FocusNode());
    nombreTextController.clear();
    edadTextController.clear();
    pesoTextController.clear();
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _shadeColor = _tempShadeColor);
              },
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker() async {
    _openDialog(
      "Color picker",
      MaterialColorPicker(
        selectedColor: _shadeColor == Colors.white ? _mainColor : _shadeColor,
        onColorChange: (color) => setState(() => _tempShadeColor = color),
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
  }

  Future insertPet() async {
    try {
      await petDB.insert(Pet(
          id: m.ObjectId(),
          nombre: nombreTextController.text,
          edad: int.parse(edadTextController.text),
          peso: int.parse(pesoTextController.text),
          icon: iconChoosed.codePoint,
          color: _shadeColor.value,
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

  Future updatePet() async {
    try {
      await petDB.update(Pet(
          id: widget.petInfo.id,
          nombre: nombreTextController.text,
          edad: int.parse(edadTextController.text),
          peso: int.parse(pesoTextController.text),
          icon: iconChoosed.codePoint,
          color: _shadeColor.value,
          uid: widget.petInfo.uid));
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
    Icons.wind_power,
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
