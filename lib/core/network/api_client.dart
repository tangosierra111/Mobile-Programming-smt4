import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_exception.dart';

typedef TokenProvider = Future<String?> Function();

class ApiClient {
  ApiClient({
    http.Client? httpClient,
    TokenProvider? tokenProvider,
    String? baseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        _tokenProvider = tokenProvider ?? _firebaseToken,
        baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final http.Client _httpClient;
  final TokenProvider _tokenProvider;
  final String baseUrl;

  static Future<String?> _firebaseToken() async {
    return FirebaseAuth.instance.currentUser?.getIdToken();
  }

  Future<dynamic> get(String path, {bool authenticated = true}) async {
    return _send('GET', path, authenticated: authenticated);
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) async {
    return _send(
      'POST',
      path,
      body: body,
      authenticated: authenticated,
    );
  }

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) async {
    return _send(
      'PUT',
      path,
      body: body,
      authenticated: authenticated,
    );
  }

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    required bool authenticated,
  }) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (authenticated) {
      final token = await _tokenProvider();
      if (token == null || token.isEmpty) {
        throw const ApiException(
          message: 'Sesi Firebase tidak tersedia. Silakan login kembali.',
          statusCode: 401,
        );
      }
      headers['Authorization'] = 'Bearer $token';
    }

    final uri = Uri.parse('$baseUrl${path.startsWith('/') ? path : '/$path'}');
    final encodedBody = body == null ? null : jsonEncode(body);
    final response = switch (method) {
      'POST' => await _httpClient.post(
          uri,
          headers: headers,
          body: encodedBody,
        ),
      'PUT' => await _httpClient.put(
          uri,
          headers: headers,
          body: encodedBody,
        ),
      _ => await _httpClient.get(uri, headers: headers),
    };

    final payload = _decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        message: payload['message'] as String? ??
            'Server mengembalikan status ${response.statusCode}.',
        statusCode: response.statusCode,
        errors: _validationErrors(payload['errors']),
      );
    }

    if (payload['success'] == false) {
      throw ApiException(
        message: payload['message'] as String? ?? 'Permintaan API gagal.',
        statusCode: response.statusCode,
      );
    }

    return payload['data'];
  }

  Map<String, dynamic> _decode(String body) {
    if (body.trim().isEmpty) return <String, dynamic>{};
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } on FormatException {
      throw const ApiException(
        message: 'Server tidak mengembalikan JSON yang valid.',
      );
    }
  }

  Map<String, List<String>> _validationErrors(dynamic rawErrors) {
    if (rawErrors is! Map<String, dynamic>) return const {};
    return rawErrors.map(
      (key, value) => MapEntry(
        key,
        (value as List<dynamic>).map((item) => item.toString()).toList(),
      ),
    );
  }

  void close() => _httpClient.close();
}
