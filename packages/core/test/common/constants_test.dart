import 'package:core/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('constants should have valid values', () {
    expect(BASE_IMAGE_URL, 'https://image.tmdb.org/t/p/w500');
    expect(kRichBlack, Color(0xFF000814));
    expect(kOxfordBlue, Color(0xFF001D3D));
    expect(kPrussianBlue, Color(0xFF003566));
    expect(kMikadoYellow, Color(0xFFffc300));
    expect(kDavysGrey, Color(0xFF4B5358));
    expect(kGrey, Color(0xFF303030));

    expect(kHeading5.fontSize, 23);
    expect(kHeading6.fontSize, 19);
    expect(kSubtitle.fontSize, 15);
    expect(kBodyText.fontSize, 13);

    expect(kTextTheme.headlineMedium, isNotNull);
    expect(kTextTheme.headlineSmall, isNotNull);
    expect(kTextTheme.labelMedium, isNotNull);
    expect(kTextTheme.bodyMedium, isNotNull);

    expect(kDrawerTheme.backgroundColor, Colors.grey.shade700);
    expect(kColorScheme.primary, kMikadoYellow);
    expect(kColorScheme.surface, kRichBlack);
  });
}
