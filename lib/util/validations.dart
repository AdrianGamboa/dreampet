class Validations {
  static String validateName(String value) {
    if (value.isEmpty) return 'Por favor ingrese un dato válido.';
    final RegExp nameExp = new RegExp(r'^[A-za-zğüşöçİĞÜŞÖÇ ]+$');
    if (!nameExp.hasMatch(value))
      return 'Solo carácteres alfabéticos.';
    return null;
  }
  static String validateNumber(String value) {
    if (value.isEmpty) return 'Por favor ingrese un dato válido.';
    final RegExp nameExp = new RegExp(r'^[0-9]+$');
    if (!nameExp.hasMatch(value))
      return 'Solo carácteres numéricos.';
    return null;
  }

  static String validateEmail(String value) {
    if (value.isEmpty) return 'Por favor ingrese un correo válido.';
    final RegExp nameExp = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,2"
        r"53}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-z"
        r"A-Z0-9])?)*$");
    if (!nameExp.hasMatch(value)) return 'Correo inválido';
    return null;
  }

  static String validatePassword(String value) {
    if (value.isEmpty) return 'Por favor ingrese una contraseña.';
    return null;
  }
}
