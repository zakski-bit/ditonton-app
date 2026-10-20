import 'package:core/data/models/tv_table.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tTvTable = TvTable(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tTv = TvSeries.watchlist(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tTvMap = {
    'id': 1,
    'name': 'name',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  test('should create TvTable from entity', () {
    final result = TvTable.fromEntity(testTvDetail);
    expect(result, tTvTable);
  });

  test('should create TvTable from Map', () {
    final result = TvTable.fromMap(tTvMap);
    expect(result, tTvTable);
  });

  test('should create TvTable from Map with title fallback', () {
    final map = {
      'id': 1,
      'title': 'name',
      'posterPath': 'posterPath',
      'overview': 'overview',
    };
    final result = TvTable.fromMap(map);
    expect(result, tTvTable);
  });

  test('should return a JSON map containing proper data', () {
    final result = tTvTable.toJson();
    expect(result, tTvMap);
  });

  test('should convert to TvSeries entity', () {
    final result = tTvTable.toEntity();
    expect(result, tTv);
  });
}
