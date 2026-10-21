import 'dart:convert';

import 'package:core/core.dart';
import 'package:http/http.dart' as http;

import '../models/tv_series_detail_model.dart';
import '../models/tv_series_model.dart';
import '../models/tv_series_response.dart';

abstract class TvRemoteDataSource {
  Future<List<TvModel>> getOnTheAirTvSeries();
  Future<List<TvModel>> getPopularTvSeries();
  Future<List<TvModel>> getTopRatedTvSeries();
  Future<TvDetailResponse> getTvSeriesDetail(int id);
  Future<List<TvModel>> getTvSeriesRecommendations(int id);
  Future<List<TvModel>> searchTvSeries(String query);
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource {
  static const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const baseUrl = 'https://api.themoviedb.org/3';
  static const API_KEY = apiKey;
  static const BASE_URL = baseUrl;

  final http.Client client;

  TvRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvModel>> getOnTheAirTvSeries() async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/on_the_air?$apiKey'),
    );

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getPopularTvSeries() async {
    final response = await client.get(Uri.parse('$baseUrl/tv/popular?$apiKey'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTopRatedTvSeries() async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/top_rated?$apiKey'),
    );

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailResponse> getTvSeriesDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/tv/$id?$apiKey'));

    if (response.statusCode == 200) {
      return TvDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvSeriesRecommendations(int id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/$id/recommendations?$apiKey'),
    );

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTvSeries(String query) async {
    final uri = Uri.parse('$baseUrl/search/tv').replace(
      queryParameters: {
        'api_key': apiKey.substring('api_key='.length),
        'query': query,
      },
    );
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }
}
