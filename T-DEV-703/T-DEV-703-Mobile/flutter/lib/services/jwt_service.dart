import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bite/models/jwt.dart';

class JwtService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'jwt';
  final ValueNotifier<String?> tokenNotifier = ValueNotifier(null);
  Jwt? jwtPayload;

  String? get token => tokenNotifier.value;

  set token(String? newToken) {
    tokenNotifier.value = newToken;
    if (newToken != null) {
      _storage.write(key: _tokenKey, value: newToken);
      jwtPayload = Jwt.fromJwtString(newToken);
    } else {
      _storage.delete(key: _tokenKey);
      jwtPayload = null;
    }
  }

  Future<void> init() async {
    tokenNotifier.value = await _storage.read(key: _tokenKey);
    if (tokenNotifier.value != null) {
      jwtPayload = Jwt.fromJwtString(tokenNotifier.value!);
    }
  }

  bool hasToken() => tokenNotifier.value != null;

  // Factory constructor to ensure proper initialization
  JwtService._create();

  static Future<JwtService> create() async {
    final service = JwtService._create();
    await service.init();
    return service;
  }
}