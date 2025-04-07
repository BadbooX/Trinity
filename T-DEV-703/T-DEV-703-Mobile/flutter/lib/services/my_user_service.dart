import 'dart:async';
import 'dart:convert';
import 'package:bite/services/router.dart';
import 'package:flutter/foundation.dart';
import 'package:bite/services/http_service.dart';
import 'package:bite/services/jwt_service.dart';
import 'package:get_it/get_it.dart';
import 'package:bite/models/address.dart';

final getIt = GetIt.instance;

class User {
  String firstName;
  String lastName;
  String fullName;
  String email;
  String? phone;
  List<Map<String, dynamic>>? addresses;
  Address? address;

  User({
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    this.addresses = const [],
    this.address,
    this.phone,
    // required this.role,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        fullName: json['fullName'] ??
            '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}',
        email: json['email'] ?? '',
        phone: json['phoneNumber'],
        addresses: List.from(json['address']).map((address) {
          return Map<String, dynamic>.from(address);
        }).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address
    };
  }
}

class MyUserService {
  ValueNotifier<User?> user = ValueNotifier(null);
  final JwtService _jwtService = getIt<JwtService>();
  final HttpClientApi _httpClient = getIt<HttpClientApi>();
  Timer? _debounceTimer;

  MyUserService() {
    _initializeUser();
    _listenToTokenChanges();
  }

  void _initializeUser() {
    if (_jwtService.hasToken()) {
      fetchUserFromApi();
    } else {
      user.value = null;
    }
  }

  void _listenToTokenChanges() {
    _jwtService.tokenNotifier.addListener(() {
      // Debounce rapid token changes (e.g., wait 300ms before reacting)
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        if (_jwtService.hasToken()) {
          fetchUserFromApi();
        } else {
          user.value = null;
        }
        if (kDebugMode) {
          print('User updated: ${user.value?.fullName ?? 'No user'}');
        }
      });
    });
  }

  Future<void> fetchUserFromApi() async {
    if (!_jwtService.hasToken()) {
      user.value = null;
      router.go('/sign-in');
      return;
    }

    try {
      final response = await _httpClient.get(Uri.parse('/api/users/my'));
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body) as Map<String, dynamic>;
        print(userData);
        user.value = User.fromJson(userData);
        if (kDebugMode) {
          print('User fetched from API: ${user.value!.addresses}');
        }
      } else {
        if (kDebugMode) {
          print('Failed to fetch user: ${response.statusCode}');
        }
        user.value = null;
        router.go('/sign-in');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user from API: $e');
      }
      user.value = null;
    }
  }

  Future<void> updateUser(User updatedUser) async {
    if (!_jwtService.hasToken()) {
      if (kDebugMode) {
        print('No token available. Cannot update user.');
      }
      return;
    }

    if (updatedUser.phone == '') {
      updatedUser.phone = null;
    }

    try {
      final response = await _httpClient.put(
        Uri.parse('/api/users/my'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': updatedUser.firstName,
          'lastName': updatedUser.lastName,
          'email': updatedUser.email,
          'phoneNumber': updatedUser.phone,
          'address': updatedUser.address?.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        // Check if response body is not empty before trying to parse it
        if (response.body.isNotEmpty) {
          final body = jsonDecode(response.body) as Map<String, dynamic>;
          if (body.containsKey('user')) {
            user.value = User.fromJson(body['user']);
          } else {
            // API might return the user directly without a 'user' wrapper
            user.value = User.fromJson(body);
          }
        }

        // Refresh user data from API to ensure we have the latest
        await fetchUserFromApi();

        if (kDebugMode) {
          print('User updated successfully: ${user.value!.fullName}');
          print('User updated successfully: ${user.value!.addresses}');
        }
      } else {
        if (kDebugMode) {
          print('Failed to update user: ${response.statusCode}');
        }
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user: $e');
      }
      rethrow; // Re-throw the exception so the UI can handle it
    }
  }

  // In MyUserService class, change deleteUser to return void and throw errors
  Future<void> deleteUser() async {
    if (!_jwtService.hasToken()) {
      if (kDebugMode) {
        print('No token available. Cannot delete user.');
      }
      throw Exception('No authentication token available');
    }
    try {
      final response = await _httpClient.delete(
        Uri.parse('/api/users/my'),
        // headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Clear user data
        clearUser();
        // Clear token
        _jwtService.token = null;
        if (kDebugMode) {
          print('User deleted successfully');
        }
      } else {
        if (kDebugMode) {
          print('Failed to delete user: ${response.statusCode}');
        }
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user: $e');
      }
      throw Exception('Error deleting user: $e');
    }
  }

  bool get isUserLoggedIn => user.value != null && _jwtService.hasToken();

  void clearUser() {
    user.value = null;
  }

  void dispose() {
    _debounceTimer?.cancel();
    // Note: Do not dispose tokenNotifier as it might be used elsewhere.
    // If you own it, you can dispose it here.
  }
}
