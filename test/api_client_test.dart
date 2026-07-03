import 'package:app_46/core/network/api_client.dart';
import 'package:app_46/core/network/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('ApiClient sends Firebase token and unwraps data', () async {
    final client = ApiClient(
      baseUrl: 'http://localhost/api/v1',
      tokenProvider: () async => 'firebase-token',
      httpClient: MockClient((request) async {
        expect(request.headers['Authorization'], 'Bearer firebase-token');
        expect(request.headers['Accept'], 'application/json');
        return http.Response(
          '{"success":true,"message":"OK","data":{"id":1},"meta":null}',
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final data = await client.get('/courses/1/dashboard');

    expect(data, {'id': 1});
    client.close();
  });

  test('ApiClient converts validation response to ApiException', () async {
    final client = ApiClient(
      baseUrl: 'http://localhost/api/v1',
      tokenProvider: () async => 'firebase-token',
      httpClient: MockClient((_) async {
        return http.Response(
          '{"success":false,"message":"Tidak valid",'
          '"errors":{"status":["Status wajib diisi."]}}',
          422,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await expectLater(
      client.put('/meetings/1/progress', body: {}),
      throwsA(
        isA<ApiException>()
            .having((error) => error.statusCode, 'statusCode', 422)
            .having(
          (error) => error.errors['status'],
          'validation errors',
          ['Status wajib diisi.'],
        ),
      ),
    );
    client.close();
  });
}
