import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class Jwt {
  late final int id;
  late final String token;
  late final DateTime expiresAt;

  Jwt({
    required this.id,
    required this.token,
    required this.expiresAt,
  });

  Jwt.fromJwtString(String jwtString) {
    final jwt = JWT.decode(jwtString);

    expiresAt = DateTime.parse(jwt.payload['exp'].toString());
    id = jwt.payload['id'] as int;
    token = jwt.payload['token'] as String;
  }

  Jwt.fromJson(Map<String, dynamic> json)
      : expiresAt = DateTime.parse(json['exp'].toString()),
        id = json['id'] as int,
        token = json['token'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'token': token,
        'exp': expiresAt.toIso8601String(),
      };
}
