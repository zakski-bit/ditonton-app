import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HttpSSLPinning', () {
    test('client should return http.Client instance', () {
      final client = HttpSSLPinning.client;
      expect(client, isNotNull);
    });

    test('createLEClient should return IOClient', () async {
      final client = await HttpSSLPinning.createLEClient();
      expect(client, isNotNull);
    });

    test('init should initialize client', () async {
      await HttpSSLPinning.init();
      expect(HttpSSLPinning.client, isNotNull);
    });
  });
}
