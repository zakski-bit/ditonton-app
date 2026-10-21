import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../bloc/detail/movie_detail_bloc.dart';
import '../bloc/detail/movie_detail_event.dart';
import '../bloc/detail/movie_detail_state.dart';
import '../bloc/recommendations/movie_recommendations_bloc.dart';
import '../bloc/recommendations/movie_recommendations_event.dart';
import '../bloc/recommendations/movie_recommendations_state.dart';
import '../bloc/watchlist/watchlist_movie_bloc.dart';
import '../bloc/watchlist/watchlist_movie_event.dart';
import '../bloc/watchlist/watchlist_movie_state.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = movieDetailRoute;
  static const ROUTE_NAME = routeName;

  final int id;
  const MovieDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<MovieDetailBloc>().add(FetchMovieDetail(widget.id));
        context.read<MovieRecommendationsBloc>().add(
          FetchMovieRecommendations(widget.id),
        );
        context.read<WatchlistMovieBloc>().add(
          LoadWatchlistMovieStatus(widget.id),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieDetailLoaded) {
            final movie = state.movieDetail;
            return SafeArea(child: DetailContent(movie));
          } else if (state is MovieDetailError) {
            return Center(
              child: Text(state.message, key: const Key('error_message')),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;

  const DetailContent(this.movie, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageUrl${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: richBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.title, style: heading5),
                            _MovieWatchlistButton(movie: movie),
                            Text(_showGenres(movie.genres)),
                            Text(_showDuration(movie.runtime)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: mikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: heading6),
                            Text(movie.overview),
                            const SizedBox(height: 16),
                            Text('Recommendations', style: heading6),
                            BlocBuilder<
                              MovieRecommendationsBloc,
                              MovieRecommendationsState
                            >(
                              builder: (context, state) {
                                if (state is MovieRecommendationsLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is MovieRecommendationsError) {
                                  return Text(state.message);
                                } else if (state
                                    is MovieRecommendationsLoaded) {
                                  final recommendations = state.movies;
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final recMovie = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                MovieDetailPage.routeName,
                                                arguments: recMovie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '$baseImageUrl${recMovie.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                errorWidget: (
                                                  context,
                                                  url,
                                                  error,
                                                ) => const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: richBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class _MovieWatchlistButton extends StatelessWidget {
  final MovieDetail movie;

  const _MovieWatchlistButton({required this.movie});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WatchlistMovieBloc, WatchlistMovieState>(
      listenWhen: (previous, current) =>
          previous.watchlistMessage != current.watchlistMessage &&
          current.watchlistMessage.isNotEmpty,
      listener: (context, state) {
        final message = state.watchlistMessage;
        if (message == WatchlistMovieState.watchlistAddSuccessMessage ||
            message == WatchlistMovieState.watchlistRemoveSuccessMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 1),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: Text(message));
            },
          );
        }
      },
      builder: (context, state) {
        final isAddedWatchlist = state.isAddedToWatchlist;
        return FilledButton(
          onPressed: () {
            if (!isAddedWatchlist) {
              context.read<WatchlistMovieBloc>().add(AddWatchlistMovie(movie));
            } else {
              context.read<WatchlistMovieBloc>().add(
                RemoveWatchlistMovie(movie),
              );
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isAddedWatchlist
                  ? const Icon(Icons.check)
                  : const Icon(Icons.add),
              const Text('Watchlist'),
            ],
          ),
        );
      },
    );
  }
}
