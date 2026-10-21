import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String baseImageUrl = 'https://image.tmdb.org/t/p/w500';

// route names
const String homeMovieRoute = '/home';
const String popularMoviesRoute = '/popular-movie';
const String topRatedMoviesRoute = '/top-rated-movie';
const String movieDetailRoute = '/detail';
const String searchMovieRoute = '/search';

const String homeTvRoute = '/home-tv';
const String popularTvRoute = '/popular-tv';
const String topRatedTvRoute = '/top-rated-tv';
const String onTheAirTvRoute = '/on-the-air-tv';
const String tvDetailRoute = '/detail-tv';
const String searchTvRoute = '/search-tv';

const String watchlistRoute = '/watchlist-movie';
const String aboutRoute = '/about';

// colors (without k prefix, unused kOxfordBlue, kDavysGrey, kGrey removed)
const Color richBlack = Color(0xFF000814);
const Color prussianBlue = Color(0xFF003566);
const Color mikadoYellow = Color(0xFFffc300);

// text style (without k prefix)
final TextStyle heading5 = GoogleFonts.poppins(
  fontSize: 23,
  fontWeight: FontWeight.w400,
);
final TextStyle heading6 = GoogleFonts.poppins(
  fontSize: 19,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.15,
);
final TextStyle subtitle = GoogleFonts.poppins(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.15,
);
final TextStyle bodyText = GoogleFonts.poppins(
  fontSize: 13,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.25,
);

// text theme
final textTheme = TextTheme(
  headlineMedium: heading5,
  headlineSmall: heading6,
  labelMedium: subtitle,
  bodyMedium: bodyText,
);

final drawerTheme = DrawerThemeData(backgroundColor: Colors.grey.shade700);

const colorScheme = ColorScheme(
  primary: mikadoYellow,
  secondary: prussianBlue,
  secondaryContainer: prussianBlue,
  surface: richBlack,
  error: Colors.red,
  onPrimary: richBlack,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);
