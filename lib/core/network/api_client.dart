import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../error/exceptions.dart';

class ApiClient {
  const ApiClient({http.Client? client}) : _client = client;

  final http.Client? _client;
  static const _timeout = Duration(seconds: 15);

  Future<http.Response> get(
    Uri uri, {
    String label = 'API',
    int retries = 1,
  }) async {
    var attempt = 0;
    while (true) {
      try {
        final client = _client ?? http.Client();
        final response = await client.get(uri).timeout(_timeout);
        if (_shouldRetry(response.statusCode) && attempt < retries) {
          attempt += 1;
          await Future<void>.delayed(Duration(milliseconds: 350 * attempt));
          continue;
        }
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }
        throw ServerException(_messageForResponse(label, response));
      } on TimeoutException {
        if (attempt < retries) {
          attempt += 1;
          continue;
        }
        throw ServerException('$label timed out. Please try again.');
      } on http.ClientException catch (e) {
        if (attempt < retries) {
          attempt += 1;
          continue;
        }
        throw ServerException('$label network error: ${e.message}');
      }
    }
  }

  dynamic decodeJson(http.Response response, {required String label}) {
    try {
      return jsonDecode(response.body);
    } catch (_) {
      throw ServerException('$label returned invalid JSON.');
    }
  }

  bool _shouldRetry(int statusCode) =>
      statusCode == 429 ||
      statusCode == 500 ||
      statusCode == 502 ||
      statusCode == 503 ||
      statusCode == 504;

  String _messageForResponse(String label, http.Response response) {
    final reason = _extractReason(response.body);
    final detail = reason == null ? '' : ': $reason';
    switch (response.statusCode) {
      case 400:
        return '$label rejected the request$detail';
      case 403:
        return '$label rejected the NASA API key or quota$detail';
      case 404:
        return '$label data was not found$detail';
      case 429:
        return '$label rate limit reached. Try again later$detail';
      case 500:
      case 502:
      case 503:
      case 504:
        return '$label is temporarily unavailable$detail';
      default:
        return '$label error ${response.statusCode}$detail';
    }
  }

  String? _extractReason(String body) {
    if (body.isEmpty) return null;
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final reason =
            decoded['reason'] ??
            decoded['msg'] ??
            decoded['message'] ??
            decoded['error'] ??
            decoded['error_message'];
        if (reason != null) return reason.toString();
      }
    } catch (_) {
      final trimmed = body.replaceAll(RegExp(r'\s+'), ' ').trim();
      if (trimmed.isNotEmpty) {
        return trimmed.length > 160 ? trimmed.substring(0, 160) : trimmed;
      }
    }
    return null;
  }
}
