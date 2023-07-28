import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:reading/shared/exceptions/rest_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rest_api.g.dart';

typedef Json = Map<String, dynamic>;

enum RestMethod { get, post }

@Riverpod(keepAlive: true)
RestApi restApi(RestApiRef ref) {
  return DioRestApi(
    server: 'http://192.168.0.169:8002/api',
  );
}

class DioRestApi extends RestApi {
  DioRestApi({
    required String server,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: server,
            connectTimeout: const Duration(seconds: 5),
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
            },
          ),
        );

  final Dio _dio;

  @override
  bool get isAuthorized => _dio.options.headers.containsKey('authorization');

  @override
  void authorize(String scheme, String token) {
    _dio.options.headers['authorization'] = '$scheme token';
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    Json? body,
  }) =>
      _request(RestMethod.get, path, query: query, body: body);

  @override
  Future<dynamic> post(
    String path, {
    Json? body,
  }) =>
      _request(RestMethod.post, path, body: body);

  @override
  Future<dynamic> upload(
    String path, {
    required String field,
    required File file,
  }) async {
    log(
      'upload $path\n'
      'file: ${file.path}',
      name: 'RestApi',
    );

    final bytes = file.readAsBytesSync();

    final multipartFile = MultipartFile.fromBytes(bytes)..finalize();
    final formData = FormData()
      ..files.add(MapEntry(field, multipartFile))
      ..finalize();

    return _request(RestMethod.post, path, body: formData);
  }

  Future<dynamic> _request(
    RestMethod method,
    String path, {
    Map<String, dynamic>? query,
    Object? body,
  }) async {
    log(
      '$method $path\n'
      'query: $query\n'
      'body: $body',
      name: 'RestApi',
    );

    try {
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
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          throw BadResponseRestException(
            code: e.response!.statusCode!,
            message: e.response!.statusMessage!,
          );
        case _:
          throw const NoResponseRestException();
      }
    } on SocketException {
      throw const NoResponseRestException();
    }
  }
}

abstract class RestApi {
  bool get isAuthorized;

  void authorize(String scheme, String token);
  Future<dynamic> get(String path, {Map<String, dynamic>? query, Json? body});
  Future<dynamic> post(String path, {Json? body});
  Future<dynamic> upload(
    String path, {
    required String field,
    required File file,
  });
}
