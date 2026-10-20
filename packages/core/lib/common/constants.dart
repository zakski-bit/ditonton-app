import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w500';

// route names
const String HOME_MOVIE_ROUTE = '/home';
const String POPULAR_MOVIES_ROUTE = '/popular-movie';
const String TOP_RATED_MOVIES_ROUTE = '/top-rated-movie';
const String MOVIE_DETAIL_ROUTE = '/detail';
const String SEARCH_MOVIE_ROUTE = '/search';

const String HOME_TV_ROUTE = '/home-tv';
const String POPULAR_TV_ROUTE = '/popular-tv';
const String TOP_RATED_TV_ROUTE = '/top-rated-tv';
const String ON_THE_AIR_TV_ROUTE = '/on-the-air-tv';
const String TV_DETAIL_ROUTE = '/detail-tv';
const String SEARCH_TV_ROUTE = '/search-tv';

const String WATCHLIST_ROUTE = '/watchlist-movie';
const String ABOUT_ROUTE = '/about';

// colors
const Color kRichBlack = Color(0xFF000814);
const Color kOxfordBlue = Color(0xFF001D3D);
const Color kPrussianBlue = Color(0xFF003566);
const Color kMikadoYellow = Color(0xFFffc300);
const Color kDavysGrey = Color(0xFF4B5358);
const Color kGrey = Color(0xFF303030);

// text style
final TextStyle kHeading5 =
    GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w400);
final TextStyle kHeading6 = GoogleFonts.poppins(
    fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15);
final TextStyle kSubtitle = GoogleFonts.poppins(
    fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.15);
final TextStyle kBodyText = GoogleFonts.poppins(
    fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.25);

// text theme
final kTextTheme = TextTheme(
  headlineMedium: kHeading5,
  headlineSmall: kHeading6,
  labelMedium: kSubtitle,
  bodyMedium: kBodyText,
);

final kDrawerTheme = DrawerThemeData(
  backgroundColor: Colors.grey.shade700,
);

const kColorScheme = ColorScheme(
  primary: kMikadoYellow,
  secondary: kPrussianBlue,
  secondaryContainer: kPrussianBlue,
  surface: kRichBlack,
  error: Colors.red,
  onPrimary: kRichBlack,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);
