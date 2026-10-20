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
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
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

  const MyApp({Key? key, this.analyticsObserver}) : super(key: key);

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
        BlocProvider(create: (_) => di.locator<OnTheAirTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TvSeriesDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TvSeriesRecommendationsBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTvSeriesBloc>()),

        // Search BLoCs
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<TvSearchBloc>()),
      ],
      child: MaterialApp(
        title: 'Ditonton',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [
          routeObserver,
          if (analyticsObserver != null) analyticsObserver!,
        ],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HOME_MOVIE_ROUTE:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case POPULAR_MOVIES_ROUTE:
              return CupertinoPageRoute(
                builder: (_) => const PopularMoviesPage(),
              );
            case TOP_RATED_MOVIES_ROUTE:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedMoviesPage(),
              );
            case MOVIE_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SEARCH_MOVIE_ROUTE:
              return CupertinoPageRoute(builder: (_) => const SearchPage());
            case WATCHLIST_ROUTE:
              return MaterialPageRoute(builder: (_) => const WatchlistPage());
            case ABOUT_ROUTE:
              return MaterialPageRoute(builder: (_) => AboutPage());

            // TV Series Routes
            case HOME_TV_ROUTE:
              return MaterialPageRoute(
                builder: (_) => const HomeTvSeriesPage(),
              );
            case ON_THE_AIR_TV_ROUTE:
              return CupertinoPageRoute(
                builder: (_) => const OnTheAirTvSeriesPage(),
              );
            case POPULAR_TV_ROUTE:
              return CupertinoPageRoute(
                builder: (_) => const PopularTvSeriesPage(),
              );
            case TOP_RATED_TV_ROUTE:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedTvSeriesPage(),
              );
            case TV_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case SEARCH_TV_ROUTE:
              return CupertinoPageRoute(
                builder: (_) => const SearchTvSeriesPage(),
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
