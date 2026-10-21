import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/data/models/tv_series_detail_model.dart';
import 'package:tv/data/models/tv_series_response.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get On The Air TV Series', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/on_the_air.json')),
    ).tvList;

    test(
      'should return list of TvModel when the response code is 200',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
            .thenAnswer(
              (_) async =>
                  http.Response(readJson('dummy_data/on_the_air.json'), 200),
            );
        // act
        final result = await dataSource.getOnTheAirTvSeries();
        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getOnTheAirTvSeries();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular TV Series', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/popular_tv.json')),
    ).tvList;

    test(
      'should return list of TvModel when response is success (200)',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
            .thenAnswer(
              (_) async =>
                  http.Response(readJson('dummy_data/popular_tv.json'), 200),
            );
        // act
        final result = await dataSource.getPopularTvSeries();
        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getPopularTvSeries();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated TV Series', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/top_rated_tv.json')),
    ).tvList;

    test('should return list of TvModel when response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer(
            (_) async =>
                http.Response(readJson('dummy_data/top_rated_tv.json'), 200),
          );
      // act
      final result = await dataSource.getTopRatedTvSeries();
      // assert
      expect(result, equals(tTvList));
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTopRatedTvSeries();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get TV Series Detail', () {
    const tId = 1;
    final tTvDetail = TvDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_detail.json')),
    );

    test(
      'should return TV Series detail when the response code is 200',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
            .thenAnswer(
              (_) async =>
                  http.Response(readJson('dummy_data/tv_detail.json'), 200),
            );
        // act
        final result = await dataSource.getTvSeriesDetail(tId);
        // assert
        expect(result, equals(tTvDetail));
      },
    );

    test(
      'should throw ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvSeriesDetail(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get TV Series Recommendations', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/tv_recommendations.json')),
    ).tvList;
    const tId = 1;

    test(
      'should return list of TvModel when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_recommendations.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getTvSeriesRecommendations(tId);
        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvSeriesRecommendations(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search TV Series', () {
    final tSearchResult = TvResponse.fromJson(
      json.decode(readJson('dummy_data/search_squid_game_tv.json')),
    ).tvList;
    const tQuery = 'Squid Game';

    final tUri = Uri.parse('$baseUrl/search/tv').replace(
      queryParameters: {
        'api_key': apiKey.substring('api_key='.length),
        'query': tQuery,
      },
    );

    test('should return list of TvModel when response code is 200', () async {
      // arrange
      when(mockHttpClient.get(tUri)).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/search_squid_game_tv.json'),
          200,
        ),
      );
      // act
      final result = await dataSource.searchTvSeries(tQuery);
      // assert
      expect(result, equals(tSearchResult));
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(mockHttpClient.get(tUri))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.searchTvSeries(tQuery);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
