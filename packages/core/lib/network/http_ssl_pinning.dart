import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class HttpSSLPinning {
  static http.Client? _client;
  static http.Client get client => _client ?? http.Client();

  static Future<http.Client> get _instance async =>
      _client ??= await createLEClient();

  static Future<void> init() async {
    _client = await _instance;
  }

  static Future<http.Client> createLEClient({
    SecurityContext? customContext,
    Uint8List? certBytes,
  }) async {
    SecurityContext context =
        customContext ?? SecurityContext(withTrustedRoots: false);
    try {
      final bytes =
          certBytes ??
          (await rootBundle.load('assets/certificates/certificates.pem')).buffer
              .asUint8List();
      context.setTrustedCertificatesBytes(bytes);
    } on SocketException catch (_) {
      rethrow;
    } catch (_) {
      // Gracefully handle in testing environments where rootBundle is unavailable
    }
    final httpClient = HttpClient(context: context);
    httpClient.badCertificateCallback = (
      X509Certificate cert,
      String host,
      int port,
    ) => false;
    return IOClient(httpClient);
  }
}
