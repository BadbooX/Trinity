import 'dart:convert';
import 'package:bite/services/router.dart';
import 'package:bite/validators/password.dart';
import 'package:bite/validators/phone.dart';
import 'package:get_it/get_it.dart';

import 'package:bite/validators/email.dart';

import 'package:bite/services/http_service.dart';
import 'package:bite/services/jwt_service.dart';

final getIt = GetIt.instance;

class AuthService {
  final JwtService _jwtService = getIt<JwtService>();
  final HttpClientApi _httpClient = getIt<HttpClientApi>();

  AuthService();

  /// Logs in the user and stores the JWT token if successful.
  Future<bool> login(String email, String password) async {
    var response = await _httpClient.post(Uri.parse('/api/login'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'email': email,
          'password': password,
        }));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseData = json.decode(response.body);
      String? token = responseData['token'];
      if (token != null) {
        _jwtService.token = token; // Store the token using JwtService
        return true;
      } else {
        // Use a logging framework instead of print
        // Example: Logger().e('Token not found in response');
        return Future.error('Token not found in response');
      }
    } else {
      return false;
    }
  }

  bool get isLoggedIn => _jwtService.token != null;

  /// Registers a new user (placeholder implementation).
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    // data validation
    if (!isValidEmail(email) ||
        !isValidPhone(phone) ||
        !isValidPassword(password)) {
      Future.error('Invalid data');
    }

    var response = await _httpClient.post(Uri.parse('/api/register'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phone': phone,
          'password': password,
        }));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  /// Handles forgot password functionality (placeholder implementation).
  Future<void> forgotPassword(String email) async {
    // Implementation for forgot password can be added here
  }

  /// Maintains the user session (placeholder implementation).
  Future<void> maintainSession() async {
    // Implementation for session maintenance can be added here
  }

  /// Logs out the user and clears the JWT token.
  void logout() {
    _jwtService.token = null;
    router.go('/sign-in');
  }
}
