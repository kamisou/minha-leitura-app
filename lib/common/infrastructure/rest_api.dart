import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:reading/configuration/configuration.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rest_api.g.dart';

@riverpod
RestApi restApi(RestApiRef ref) {
  return RestApi(
    server: ref.watch(configProvider).restApiUrl,
    authScheme: ref.watch(configProvider).restApiAuthScheme,
  );
}

typedef Json = Map<String, dynamic>;

class RestApi {
  RestApi({
    required String server,
    required String authScheme,
  })  : _dio = Dio(
          BaseOptions(
            baseUrl: server,
            connectTimeout: const Duration(seconds: 5),
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
            },
          ),
        ),
        _authScheme = authScheme;

  final Dio _dio;

  final String _authScheme;

  void authorize(String token) {
    _dio.options.headers['authorization'] = '$_authScheme token';
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    Json? body,
  }) =>
      _request(RestMethod.get, path, query: query, body: body);

  Future<dynamic> post(
    String path, {
    Json? body,
  }) =>
      _request(RestMethod.post, path, body: body);

  Future<dynamic> _request(
    RestMethod method,
    String path, {
    Map<String, dynamic>? query,
    Json? body,
  }) async {
    log(
      '$method $path\n'
      'query: $query\n'
      'body: $body',
      name: 'RestApi',
    );

    final response = switch (method) {
      RestMethod.get => await _dio.get<dynamic>(
          path,
          data: body,
          queryParameters: query,
        ),
      RestMethod.post => await _dio.post<dynamic>(
          path,
          data: body,
        ),
    };

    return response.data;
  }
}

enum RestMethod { get, post }
