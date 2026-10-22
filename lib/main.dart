import 'dart:async';
import 'dart:ui';

import 'package:about/about.dart';
import 'package:core/core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:search/search.dart';
import 'package:tv/tv.dart';
import 'package:watchlist/watchlist.dart';

import 'injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HttpSSLPinning.init();

  NavigatorObserver? analyticsObserver;
  try {
    await Firebase.initializeApp();
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      originalOnError?.call(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      unawaited(
        FirebaseCrashlytics.instance
            .recordError(error, stack, fatal: true)
            .catchError((Object reportingError, StackTrace reportingStack) {
              debugPrint('Failed to report uncaught error: $reportingError');
            }),
      );
      return true;
    };
    analyticsObserver = FirebaseAnalyticsObserver(
      analytics: FirebaseAnalytics.instance,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  di.init();

  runApp(MyApp(analyticsObserver: analyticsObserver));
}

class MyApp extends StatelessWidget {
  final NavigatorObserver? analyticsObserver;

  const MyApp({super.key, this.analyticsObserver});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Movie BLoCs
        BlocProvider(create: (_) => di.locator<NowPlayingMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieRecommendationsBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieBloc>()),

        // TV Series BLoCs
        BlocProvider(create: (_) => di.locator<OnTheAirTVSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTVSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTVSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TVSeriesDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TVSeriesRecommendationsBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTVSeriesBloc>()),

        // Search BLoCs
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<TVSearchBloc>()),
      ],
      child: MaterialApp(
        title: 'Ditonton',
        theme: ThemeData.dark().copyWith(
          colorScheme: colorScheme,
          primaryColor: richBlack,
          scaffoldBackgroundColor: richBlack,
          textTheme: textTheme,
          drawerTheme: drawerTheme,
        ),
        home: const HomeMoviePage(),
        navigatorObservers: [
          routeObserver,
          if (analyticsObserver != null) analyticsObserver!,
        ],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case homeMovieRoute:
              return MaterialPageRoute(builder: (_) => const HomeMoviePage());
            case popularMoviesRoute:
              return CupertinoPageRoute(
                builder: (_) => const PopularMoviesPage(),
              );
            case topRatedMoviesRoute:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedMoviesPage(),
              );
            case movieDetailRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case searchMovieRoute:
              return CupertinoPageRoute(builder: (_) => const SearchPage());
            case watchlistRoute:
              return MaterialPageRoute(builder: (_) => const WatchlistPage());
            case aboutRoute:
              return MaterialPageRoute(builder: (_) => const AboutPage());

            // TV Series Routes
            case homeTvRoute:
              return MaterialPageRoute(
                builder: (_) => const HomeTVSeriesPage(),
              );
            case onTheAirTvRoute:
              return CupertinoPageRoute(
                builder: (_) => const OnTheAirTVSeriesPage(),
              );
            case popularTvRoute:
              return CupertinoPageRoute(
                builder: (_) => const PopularTVSeriesPage(),
              );
            case topRatedTvRoute:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedTVSeriesPage(),
              );
            case tvDetailRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVSeriesDetailPage(id: id),
                settings: settings,
              );
            case searchTvRoute:
              return CupertinoPageRoute(
                builder: (_) => const SearchTVSeriesPage(),
              );

            default:
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(child: Text('Page not found :(')),
                ),
              );
          }
        },
      ),
    );
  }
}
