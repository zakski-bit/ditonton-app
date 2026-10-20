import 'package:core/data/models/movie_table.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tMovie = Movie.watchlist(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tMovieMap = {
    'id': 1,
    'title': 'title',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  test('should create MovieTable from entity', () {
    final result = MovieTable.fromEntity(testMovieDetail);
    expect(result, tMovieTable);
  });

  test('should create MovieTable from Map', () {
    final result = MovieTable.fromMap(tMovieMap);
    expect(result, tMovieTable);
  });

  test('should return a JSON map containing proper data', () {
    final result = tMovieTable.toJson();
    expect(result, tMovieMap);
  });

  test('should convert to Movie entity', () {
    final result = tMovieTable.toEntity();
    expect(result, tMovie);
  });
}
