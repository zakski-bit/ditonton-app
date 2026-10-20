import 'package:tv/data/models/tv_series_model.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tTvModel = TvModel(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTv = TvSeries(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

  test('should be a subclass of TvSeries entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });

  test('should return a JSON map containing proper data', () async {
    final result = tTvModel.toJson();
    final expectedJsonMap = {
      "adult": false,
      "backdrop_path": 'backdropPath',
      "genre_ids": [1, 2, 3],
      "id": 1,
      "original_name": 'originalName',
      "overview": 'overview',
      "popularity": 1.0,
      "poster_path": 'posterPath',
      "first_air_date": 'firstAirDate',
      "name": 'name',
      "vote_average": 1.0,
      "vote_count": 1,
    };
    expect(result, expectedJsonMap);
  });

  test('should parse from JSON when genre_ids is null', () {
    final jsonMap = {
      "adult": false,
      "backdrop_path": 'backdropPath',
      "genre_ids": null,
      "id": 1,
      "original_name": 'originalName',
      "overview": 'overview',
      "popularity": 1.0,
      "poster_path": 'posterPath',
      "first_air_date": 'firstAirDate',
      "name": 'name',
      "vote_average": 1.0,
      "vote_count": 1,
    };
    final result = TvModel.fromJson(jsonMap);
    expect(result.genreIds, []);
  });
}
