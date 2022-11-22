import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_ui/util/animations.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/enum.dart';
import 'package:social_app_ui/util/router.dart';
import 'package:social_app_ui/util/validations.dart';
import 'package:social_app_ui/views/screens/main_screen.dart';
import 'package:social_app_ui/views/widgets/custom_button.dart';
import 'package:social_app_ui/views/widgets/custom_text_field.dart';
import 'package:social_app_ui/util/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/AuthenticationService.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthenticationService _auth = AuthenticationService();
  String email, phone, password, name = '', lastName = '';
  FocusNode nameFN = FocusNode();
  FocusNode lastNameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode phoneFN = FocusNode();
  FocusNode passFN = FocusNode();
  FormMode formMode = FormMode.LOGIN;

  login() async {
    FormState form = formKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      setState(() {});
      showInSnackBar('Por favor solucione los errores.');
    } else {
      User user = await _auth.loginUser(context, email, password);
      if (user != null) Navigate.pushPageReplacement(context, MainScreen());
    }
  }

  register() async {
    FormState form = formKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      setState(() {});
      showInSnackBar('Por favor solucione los errores.');
    } else {
      User user = await _auth.createNewUser(name.trim(), lastName.trim(),
          email.trim(), phone.trim(), password.trim(), context);

      if (user != null) {
        formMode = FormMode.LOGIN;
        clearFields();
        setState(() {});
      }
    }
  }

  clearFields() {
    name = "";
    lastName = "";
    password = "";
    email = "";
    phone = "";
    formKey.currentState.reset();
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Row(
          children: [
            buildLottieContainer(),
            Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                child: Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: buildFormContainer(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildLottieContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      width: screenWidth < 700 ? 0 : screenWidth * 0.5,
      duration: Duration(milliseconds: 500),
      color: Theme.of(context).primaryColor.withOpacity(0.3),
      child: Center(
        child: Lottie.asset(
          AppAnimations.chatAnimation,
          height: 400,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  buildFormContainer() {
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Image.asset(
                  '${Constants.logoWhite}',
                )
              : Image.asset(
                  '${Constants.logoBlack}',
                ).fadeInList(0, false),
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: buildForm(),
          ),
          Visibility(
            visible: formMode == FormMode.LOGIN,
            child: Column(
              children: [
                SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      formMode = FormMode.FORGOT_PASSWORD;
                      clearFields();
                      setState(() {});
                    },
                    child: Text('¿Olvidó la contraseña?'),
                  ),
                ),
              ],
            ),
          ).fadeInList(3, false),
          SizedBox(height: 20.0),
          buildButton(),
          Visibility(
            visible: formMode == FormMode.LOGIN,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('¿No tiene una cuenta?'),
                TextButton(
                  onPressed: () {
                    formMode = FormMode.REGISTER;
                    clearFields();
                    setState(() {});
                  },
                  child: Text('Registrarse'),
                ),
              ],
            ),
          ).fadeInList(5, false),
          Visibility(
            visible: formMode != FormMode.LOGIN,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('¿Ya tiene una cuenta?'),
                TextButton(
                  onPressed: () {
                    formMode = FormMode.LOGIN;
                    clearFields();
                    setState(() {});
                  },
                  child: Text('Iniciar sesión'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Visibility(
          visible: formMode == FormMode.REGISTER,
          child: Column(
            children: [
              CustomTextField(
                enabled: !loading,
                hintText: "Nombre",
                textInputAction: TextInputAction.next,
                validateFunction: Validations.validateName,
                onSaved: (String val) {
                  name = val;
                },
                focusNode: nameFN,
                nextFocusNode: lastNameFN,
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
        Visibility(
          visible: formMode == FormMode.REGISTER,
          child: Column(
            children: [
              CustomTextField(
                enabled: !loading,
                hintText: "Apellidos",
                textInputAction: TextInputAction.next,
                validateFunction: Validations.validateName,
                onSaved: (String val) {
                  lastName = val;
                },
                focusNode: lastNameFN,
                nextFocusNode: emailFN,
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
        CustomTextField(
          enabled: !loading,
          hintText: "Correo electrónico",
          textInputAction: TextInputAction.next,
          validateFunction: Validations.validateEmail,
          onSaved: (String val) {
            email = val;
          },
          focusNode: emailFN,
          nextFocusNode: phoneFN,
        ).fadeInList(1, false),
        SizedBox(height: 20.0),
        Visibility(
          visible: formMode == FormMode.REGISTER,
          child: Column(
            children: [
              CustomTextField(
                enabled: !loading,
                hintText: "Número de teléfono",
                textInputAction: TextInputAction.next,
                validateFunction: Validations.validateNumber,
                onSaved: (String val) {
                  phone = val;
                },
                focusNode: phoneFN,
                nextFocusNode: passFN,
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
        Visibility(
          visible: formMode != FormMode.FORGOT_PASSWORD,
          child: Column(
            children: [
              CustomTextField(
                enabled: !loading,
                hintText: "Contraseña",
                textInputAction: TextInputAction.done,
                validateFunction: Validations.validatePassword,
                submitAction: login,
                obscureText: true,
                onSaved: (String val) {
                  password = val;
                },
                focusNode: passFN,
              ),
            ],
          ),
        ).fadeInList(2, false),
      ],
    );
  }

  Future resetPassword() async {
    FormState form = formKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      setState(() {});
      showInSnackBar('Por favor solucione los errores.');
    } else {
      try {
        loading = true;
        setState(() {});
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
        showInSnackBar('Solicitud de cambio de contraseña.\n'
            'Hemos enviado un correo electrónico a $email en donde podrás modificar tu contraseña por medio de un enlace adjunto.');
        loading = false;
        setState(() {});

      } on FirebaseAuthException catch (e) {
        String message = '';
        switch (e.code) {
          case 'user-not-found':
            message =
                'No existe una cuenta de usuario enlazada a la dirección de correo electrónico: $email';
            break;
          case 'invalid-email':
            message = 'El correo electrónico proporcionado es inválido.';
            break;
          case 'too-many-requests':
            message =
                'Hemos bloqueado todas las solicitudes de este dispositivo debido a que se detecto actividad inusual. Vuelva a intentarlo más tarde.';
            break;

          default:
            message = e.message;
        }
        showInSnackBar('Error.\n' + message);

        loading = false;
        setState(() {});
      }
    }
  }

  buildButton() {
    return loading
        ? Center(child: CircularProgressIndicator())
        : CustomButton(
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Theme.of(context).primaryColor
                : Colors.blue,
            label: formMode == FormMode.LOGIN
                ? "Iniciar sesión"
                : formMode == FormMode.REGISTER
                    ? "Registrarse"
                    : "Restablecer contraseña",
            onPressed: () => formMode == FormMode.LOGIN
                ? login()
                : formMode == FormMode.REGISTER
                    ? register()
                    : resetPassword(),
          ).fadeInList(4, false);
  }
}
