import 'dart:convert';

import 'package:core/core.dart';
import 'package:tv/tv.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvDetailResponse = TvDetailResponse(
    adult: false,
    backdropPath: "/path.jpg",
    genres: [GenreModel(id: 1, name: "Action")],
    id: 1,
    originalName: "Original Name",
    overview: "Overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    firstAirDate: "2020-05-05",
    name: "Name",
    voteAverage: 1.0,
    voteCount: 1,
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    seasons: [
      SeasonModel(
        id: 1,
        name: "Season 1",
        overview: "Season 1 Overview",
        posterPath: "/poster.jpg",
        seasonNumber: 1,
        episodeCount: 10,
      )
    ],
  );

  final tTvDetail = TvSeriesDetail(
    adult: false,
    backdropPath: "/path.jpg",
    genres: [Genre(id: 1, name: "Action")],
    id: 1,
    originalName: "Original Name",
    overview: "Overview",
    posterPath: "/path.jpg",
    firstAirDate: "2020-05-05",
    name: "Name",
    voteAverage: 1.0,
    voteCount: 1,
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    seasons: [
      Season(
        id: 1,
        name: "Season 1",
        overview: "Season 1 Overview",
        posterPath: "/poster.jpg",
        seasonNumber: 1,
        episodeCount: 10,
      )
    ],
  );

  group('toEntity', () {
    test('should be a subclass of TvSeriesDetail entity', () async {
      final result = tTvDetailResponse.toEntity();
      expect(result, tTvDetail);
    });
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_detail.json'));
      final result = TvDetailResponse.fromJson(jsonMap);
      expect(result, tTvDetailResponse);
    });

    test('should return a valid model from JSON when genres and seasons are null', () {
      final jsonMap = {
        "adult": false,
        "backdrop_path": "/path.jpg",
        "genres": null,
        "id": 1,
        "original_name": "Original Name",
        "overview": "Overview",
        "popularity": 1.0,
        "poster_path": "/path.jpg",
        "first_air_date": "2020-05-05",
        "name": "Name",
        "vote_average": 1.0,
        "vote_count": 1,
        "number_of_episodes": 10,
        "number_of_seasons": 1,
        "seasons": null,
      };
      final result = TvDetailResponse.fromJson(jsonMap);
      expect(result.genres, []);
      expect(result.seasons, []);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tTvDetailResponse.toJson();
      final expectedJsonMap = {
        "adult": false,
        "backdrop_path": "/path.jpg",
        "genres": [
          {"id": 1, "name": "Action"}
        ],
        "id": 1,
        "original_name": "Original Name",
        "overview": "Overview",
        "popularity": 1.0,
        "poster_path": "/path.jpg",
        "first_air_date": "2020-05-05",
        "name": "Name",
        "vote_average": 1.0,
        "vote_count": 1,
        "number_of_episodes": 10,
        "number_of_seasons": 1,
        "seasons": [
          {
            "id": 1,
            "name": "Season 1",
            "overview": "Season 1 Overview",
            "poster_path": "/poster.jpg",
            "season_number": 1,
            "episode_count": 10
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
