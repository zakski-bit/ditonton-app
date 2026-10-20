import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../bloc/detail/tv_series_detail_bloc.dart';
import '../bloc/detail/tv_series_detail_event.dart';
import '../bloc/detail/tv_series_detail_state.dart';
import '../bloc/recommendations/tv_series_recommendations_bloc.dart';
import '../bloc/recommendations/tv_series_recommendations_event.dart';
import '../bloc/recommendations/tv_series_recommendations_state.dart';
import '../bloc/watchlist/watchlist_tv_series_bloc.dart';
import '../bloc/watchlist/watchlist_tv_series_event.dart';
import '../bloc/watchlist/watchlist_tv_series_state.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = TV_DETAIL_ROUTE;

  final int id;
  const TvSeriesDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _TvSeriesDetailPageState createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TvSeriesDetailBloc>().add(FetchTvSeriesDetail(widget.id));
        context
            .read<TvSeriesRecommendationsBloc>()
            .add(FetchTvSeriesRecommendations(widget.id));
        context
            .read<WatchlistTvSeriesBloc>()
            .add(LoadWatchlistTvSeriesStatus(widget.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvSeriesDetailBloc, TvSeriesDetailState>(
        builder: (context, state) {
          if (state is TvSeriesDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvSeriesDetailLoaded) {
            final tvSeries = state.tvSeriesDetail;
            return SafeArea(
              child: DetailContent(tvSeries),
            );
          } else if (state is TvSeriesDetailError) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
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
  final TvSeriesDetail tvSeries;

  const DetailContent(this.tvSeries, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$BASE_IMAGE_URL${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvSeries.name,
                              style: kHeading5,
                            ),
                            BlocConsumer<WatchlistTvSeriesBloc,
                                WatchlistTvSeriesState>(
                              listenWhen: (previous, current) =>
                                  previous.watchlistMessage !=
                                      current.watchlistMessage &&
                                  current.watchlistMessage.isNotEmpty,
                              listener: (context, state) {
                                final message = state.watchlistMessage;
                                if (message ==
                                        WatchlistTvSeriesState
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        WatchlistTvSeriesState
                                            .watchlistRemoveSuccessMessage) {
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
                                      return AlertDialog(
                                        content: Text(message),
                                      );
                                    },
                                  );
                                }
                              },
                              builder: (context, state) {
                                final isAddedWatchlist =
                                    state.isAddedToWatchlist;
                                return FilledButton(
                                  onPressed: () {
                                    if (!isAddedWatchlist) {
                                      context.read<WatchlistTvSeriesBloc>().add(
                                          AddWatchlistTvSeries(tvSeries));
                                    } else {
                                      context.read<WatchlistTvSeriesBloc>().add(
                                          RemoveWatchlistTvSeries(tvSeries));
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
                            ),
                            Text(
                              _showGenres(tvSeries.genres),
                            ),
                            Text(
                              '${tvSeries.numberOfSeasons} Season(s), ${tvSeries.numberOfEpisodes} Episode(s)',
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvSeries.overview.isNotEmpty
                                  ? tvSeries.overview
                                  : '-',
                            ),
                            const SizedBox(height: 16),
                            if (tvSeries.seasons.isNotEmpty) ...[
                              Text(
                                'Seasons',
                                style: kHeading6,
                              ),
                              Container(
                                height: 160,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: tvSeries.seasons.length,
                                  itemBuilder: (context, index) {
                                    final season = tvSeries.seasons[index];
                                    return _buildSeasonCard(season);
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvSeriesRecommendationsBloc,
                                TvSeriesRecommendationsState>(
                              builder: (context, state) {
                                if (state is TvSeriesRecommendationsLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state
                                    is TvSeriesRecommendationsError) {
                                  return Text(state.message);
                                } else if (state
                                    is TvSeriesRecommendationsLoaded) {
                                  final recommendations = state.tvSeries;
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final recTv = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvSeriesDetailPage.ROUTE_NAME,
                                                arguments: recTv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '$BASE_IMAGE_URL${recTv.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
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
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSeasonCard(Season season) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: season.posterPath != null
                ? CachedNetworkImage(
                    imageUrl: '$BASE_IMAGE_URL${season.posterPath}',
                    width: 100,
                    height: 110,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : Container(
                    width: 100,
                    height: 110,
                    color: Colors.grey.shade800,
                    child: const Icon(Icons.tv, size: 40),
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            season.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            '${season.episodeCount} Ep.',
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
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
}
