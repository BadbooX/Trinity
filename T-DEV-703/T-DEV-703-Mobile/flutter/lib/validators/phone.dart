import 'package:phone_numbers_parser/phone_numbers_parser.dart';


bool isValidPhone(String phone) {
  try {
    return PhoneNumber.parse(phone).isValid();
  } catch (e) {
    return false;
  }
}