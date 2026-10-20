import 'package:core/data/models/season_model.dart';
import 'package:core/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tSeasonModel = SeasonModel(
    id: 1,
    name: 'Season 1',
    overview: 'Season 1 Overview',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
    episodeCount: 10,
  );

  const tSeason = Season(
    id: 1,
    name: 'Season 1',
    overview: 'Season 1 Overview',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
    episodeCount: 10,
  );

  test('should be a subclass of Season entity', () async {
    final result = tSeasonModel.toEntity();
    expect(result, tSeason);
  });

  test('should return a valid SeasonModel from JSON', () async {
    final jsonMap = {
      'id': 1,
      'name': 'Season 1',
      'overview': 'Season 1 Overview',
      'poster_path': '/poster.jpg',
      'season_number': 1,
      'episode_count': 10,
    };
    final result = SeasonModel.fromJson(jsonMap);
    expect(result, tSeasonModel);
  });

  test('should return a JSON map containing proper data', () async {
    final result = tSeasonModel.toJson();
    final expectedJson = {
      'id': 1,
      'name': 'Season 1',
      'overview': 'Season 1 Overview',
      'poster_path': '/poster.jpg',
      'season_number': 1,
      'episode_count': 10,
    };
    expect(result, expectedJson);
  });
}
