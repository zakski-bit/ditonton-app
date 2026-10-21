import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';

class WatchlistPage extends StatefulWidget {
  static const routeName = watchlistRoute;
  static const ROUTE_NAME = routeName;

  const WatchlistPage({Key? key}) : super(key: key);

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
      context.read<WatchlistTvSeriesBloc>().add(FetchWatchlistTvSeries());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
    context.read<WatchlistTvSeriesBloc>().add(FetchWatchlistTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
          bottom: const TabBar(
            indicatorColor: mikadoYellow,
            tabs: [
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
              Tab(icon: Icon(Icons.tv), text: 'TV Series'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
                builder: (context, state) {
                  if (state.watchlistState == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.watchlistState == RequestState.Loaded) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final movie = state.watchlistMovies[index];
                        return MovieCard(movie);
                      },
                      itemCount: state.watchlistMovies.length,
                    );
                  } else if (state.watchlistState == RequestState.Error) {
                    return Center(
                      key: const Key('error_message'),
                      child: Text(state.message),
                    );
                  } else {
                    return const Center(child: Text('No Watchlist'));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
                builder: (context, state) {
                  if (state.watchlistState == RequestState.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.watchlistState == RequestState.Loaded) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final tv = state.watchlistTvSeries[index];
                        return TvSeriesCard(tv);
                      },
                      itemCount: state.watchlistTvSeries.length,
                    );
                  } else if (state.watchlistState == RequestState.Error) {
                    return Center(
                      key: const Key('error_message_tv'),
                      child: Text(state.message),
                    );
                  } else {
                    return const Center(child: Text('No Watchlist'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
