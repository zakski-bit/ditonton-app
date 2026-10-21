import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: 'Action');
  final tGenre = Genre(id: 1, name: 'Action');

  group('GenreModel', () {
    test('should be a subclass of Genre entity', () async {
      final result = tGenreModel.toEntity();
      expect(result, tGenre);
    });

    test('should return a valid model from JSON', () async {
      final Map<String, dynamic> jsonMap = {'id': 1, 'name': 'Action'};
      final result = GenreModel.fromJson(jsonMap);
      expect(result, tGenreModel);
    });

    test('should return a JSON map containing proper data', () async {
      final result = tGenreModel.toJson();
      final expectedJsonMap = {'id': 1, 'name': 'Action'};
      expect(result, expectedJsonMap);
    });
  });
}
