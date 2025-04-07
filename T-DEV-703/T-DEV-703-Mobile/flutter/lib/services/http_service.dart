import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'package:bite/services/jwt_service.dart';

final getIt = GetIt.instance;

class HttpClientApi extends http.BaseClient {
  late final http.Client _inner;
  late final JwtService _jwtService;
  late final Uri _baseUri;

  HttpClientApi({bool allowSelfSigned = false}) {
    //selft signed
    if (allowSelfSigned) {
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      _inner = IOClient(httpClient);
    } else {
      _inner = http.Client();
    }

    _jwtService = getIt<JwtService>(); // Assuming getIt is set up for dependency injection
    String apiUrl = dotenv.get('API_URL', fallback: 'http://127.0.0.1:3000'); // Get API_URL from .env
    if (apiUrl.endsWith('/')) { // Remove trailing slash if present
      apiUrl = apiUrl.substring(0, apiUrl.length - 1);
    }
    _baseUri = Uri.parse(apiUrl); // Parse API URL into a Uri object
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Handle URL resolution for http.Request objects
    if (request is http.Request) {
      Uri url = request.url;
      if (url.scheme.isEmpty) {
        String path = url.toString();
        if (path.startsWith('/')) {
          path = path.substring(1);
        }
        Uri newUrl = _baseUri.resolve(path);
        final newRequest = http.Request(request.method, newUrl)
          ..persistentConnection = request.persistentConnection
          ..followRedirects = request.followRedirects
          ..maxRedirects = request.maxRedirects
          ..headers.addAll(request.headers)
          ..encoding = request.encoding;
        if (request.body.isNotEmpty) {
          newRequest.body = request.body;
        } else if (request.bodyBytes.isNotEmpty) {
          newRequest.bodyBytes = request.bodyBytes;
        }
        request = newRequest;
      }
    } else {
      print('Warning: Non-Request type, URL not modified');
    }

    // Add JWT token to headers if available
    String? token = _jwtService.token;
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    return _inner.send(request);
  }
}