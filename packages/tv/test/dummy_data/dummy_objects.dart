import 'package:core/core.dart';

final testTv = TvSeries(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: const [14, 28],
  id: 1,
  originalName: 'Original Name',
  overview: 'Overview',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  firstAirDate: '2021-09-03',
  name: 'Name',
  voteAverage: 7.2,
  voteCount: 13507,
);

final testTvList = [testTv];

final testSeason = Season(
  id: 1,
  name: 'Season 1',
  overview: 'Season 1 Overview',
  posterPath: '/poster.jpg',
  seasonNumber: 1,
  episodeCount: 10,
);

final testTvDetail = TvSeriesDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  firstAirDate: 'firstAirDate',
  name: 'name',
  voteAverage: 1,
  voteCount: 1,
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  seasons: [testSeason],
);

final testWatchlistTv = TvSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvTable = TvTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
