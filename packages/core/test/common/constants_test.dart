import 'package:core/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('constants should have valid values', () {
    expect(baseImageUrl, 'https://image.tmdb.org/t/p/w500');
    expect(richBlack, const Color(0xFF000814));
    expect(prussianBlue, const Color(0xFF003566));
    expect(mikadoYellow, const Color(0xFFffc300));

    expect(heading5.fontSize, 23);
    expect(heading6.fontSize, 19);
    expect(subtitle.fontSize, 15);
    expect(bodyText.fontSize, 13);

    expect(textTheme.headlineMedium, isNotNull);
    expect(textTheme.headlineSmall, isNotNull);
    expect(textTheme.labelMedium, isNotNull);
    expect(textTheme.bodyMedium, isNotNull);

    expect(drawerTheme.backgroundColor, Colors.grey.shade700);
    expect(colorScheme.primary, mikadoYellow);
    expect(colorScheme.surface, richBlack);
  });
}
