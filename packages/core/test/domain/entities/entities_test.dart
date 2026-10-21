import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Movie entity props test', () {
    final movie = Movie(
      adult: false,
      backdropPath: '/path.jpg',
      genreIds: [1, 2],
      id: 1,
      originalTitle: 'Original Title',
      overview: 'Overview',
      popularity: 1.0,
      posterPath: '/path.jpg',
      releaseDate: '2022-01-01',
      title: 'Title',
      video: false,
      voteAverage: 1.0,
      voteCount: 1,
    );
    expect(movie.props, [
      false,
      '/path.jpg',
      [1, 2],
      1,
      'Original Title',
      'Overview',
      1.0,
      '/path.jpg',
      '2022-01-01',
      'Title',
      false,
      1.0,
      1,
    ]);
  });

  test('MovieDetail entity props test', () {
    final movieDetail = MovieDetail(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [Genre(id: 1, name: 'Action')],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      runtime: 120,
      title: 'title',
      voteAverage: 1,
      voteCount: 1,
    );
    expect(movieDetail.props, isNotEmpty);
  });

  test('TvSeries entity props test', () {
    final tv = TvSeries(
      adult: false,
      backdropPath: '/path.jpg',
      genreIds: [1, 2],
      id: 1,
      originalName: 'Original Name',
      overview: 'Overview',
      popularity: 1.0,
      posterPath: '/path.jpg',
      firstAirDate: '2022-01-01',
      name: 'Name',
      voteAverage: 1.0,
      voteCount: 1,
    );
    expect(tv.props, isNotEmpty);
  });

  test('TvSeriesDetail entity props test', () {
    final tvDetail = TvSeriesDetail(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [Genre(id: 1, name: 'Action')],
      id: 1,
      originalName: 'originalName',
      overview: 'overview',
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      name: 'name',
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      seasons: [
        Season(
          id: 1,
          name: 'Season 1',
          overview: 'Overview',
          posterPath: '/path.jpg',
          seasonNumber: 1,
          episodeCount: 10,
        ),
      ],
      voteAverage: 1.0,
      voteCount: 1,
    );
    expect(tvDetail.props, isNotEmpty);
  });
}
