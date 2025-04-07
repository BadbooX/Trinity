
final RegExp emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

bool isValidEmail(String email) {
  return emailRegEx.hasMatch(email);
}