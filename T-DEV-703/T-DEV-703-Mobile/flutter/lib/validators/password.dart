
// Contiennent au moins un chiffre.
// Contiennent au moins une lettre minuscule.
// Contiennent au moins une lettre majuscule.
// Ont une longueur d'au moins 8 caractères.
final RegExp passwordRegEx = RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$');

bool isValidPassword(String password) {

  return passwordRegEx.hasMatch(password);
}