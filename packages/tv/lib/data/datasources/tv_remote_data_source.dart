import 'dart:convert';

import 'package:core/core.dart';
import 'package:http/http.dart' as http;

import '../models/tv_series_detail_model.dart';
import '../models/tv_series_model.dart';
import '../models/tv_series_response.dart';

abstract class TVRemoteDataSource {
  Future<List<TVModel>> getOnTheAirTvSeries();
  Future<List<TVModel>> getPopularTvSeries();
  Future<List<TVModel>> getTopRatedTvSeries();
  Future<TVDetailResponse> getTvSeriesDetail(int id);
  Future<List<TVModel>> getTvSeriesRecommendations(int id);
  Future<List<TVModel>> searchTvSeries(String query);
}

class TVRemoteDataSourceImpl implements TVRemoteDataSource {
  static const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const baseUrl = 'https://api.themoviedb.org/3';

  final http.Client client;

  TVRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TVModel>> getOnTheAirTvSeries() async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/on_the_air?$apiKey'),
    );

    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> getPopularTvSeries() async {
    final response = await client.get(Uri.parse('$baseUrl/tv/popular?$apiKey'));

    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> getTopRatedTvSeries() async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/top_rated?$apiKey'),
    );

    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TVDetailResponse> getTvSeriesDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/tv/$id?$apiKey'));

    if (response.statusCode == 200) {
      return TVDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> getTvSeriesRecommendations(int id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/$id/recommendations?$apiKey'),
    );

    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> searchTvSeries(String query) async {
    final uri = Uri.parse('$baseUrl/search/tv').replace(
      queryParameters: {
        'api_key': apiKey.substring('api_key='.length),
        'query': query,
      },
    );
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }
}

typedef TvRemoteDataSource = TVRemoteDataSource;
typedef TvRemoteDataSourceImpl = TVRemoteDataSourceImpl;
