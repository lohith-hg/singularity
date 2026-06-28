import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:singularity/core/error/exceptions.dart';
import 'package:singularity/core/network/api_client.dart';

void main() {
  test('ApiClient includes NASA error reason in failure message', () async {
    final client = ApiClient(
      client: MockClient(
        (_) async => http.Response('{"error":"API_KEY_INVALID"}', 403),
      ),
    );

    expect(
      () => client.get(Uri.https('api.nasa.gov', '/planetary/apod')),
      throwsA(
        isA<ServerException>().having(
          (e) => e.message,
          'message',
          contains('API_KEY_INVALID'),
        ),
      ),
    );
  });

  test('ApiClient decodes malformed JSON as a readable failure', () async {
    const client = ApiClient();

    expect(
      () => client.decodeJson(http.Response('not json', 200), label: 'NASA'),
      throwsA(
        isA<ServerException>().having(
          (e) => e.message,
          'message',
          'NASA returned invalid JSON.',
        ),
      ),
    );
  });
}
