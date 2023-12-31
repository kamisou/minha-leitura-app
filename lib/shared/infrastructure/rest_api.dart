import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:reading/authentication/data/repositories/token_repository.dart';
import 'package:reading/shared/exceptions/rest_exception.dart';
import 'package:reading/shared/infrastructure/debugger.dart';
import 'package:reading/shared/infrastructure/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rest_api.g.dart';

typedef Json = Map<String, dynamic>;

@Riverpod(keepAlive: true)
class RestApiServer extends _$RestApiServer {
  @override
  Future<String> build() async {
    return ref
        .read(secureStorageProvider)
        .read('rest_api_server')
        .then((value) => value ?? 'http://marlin.websix.com.br:5000/api/');
  }

  Future<void> set(String value) {
    state = AsyncData(value);
    return ref.read(secureStorageProvider).write('rest_api_server', value);
  }
}

@Riverpod(keepAlive: true)
RestApi restApi(RestApiRef ref) {
  final accessToken = ref.watch(tokenProvider);

  log('$accessToken');

  return DioRestApi(
    server: Debugger.isDebugMode
        ? ref.watch(restApiServerProvider).requireValue
        : 'https://minha-leitura-back-php.k8s.senailondrina.com/api/',
    headers: accessToken != null //
        ? {'Authorization': 'Bearer $accessToken'}
        : null,
  );
}

class DioRestApi extends RestApi {
  DioRestApi({
    required String server,
    Map<String, dynamic>? headers,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: server,
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
              if (headers != null) ...headers,
            },
          ),
        );

  final Dio _dio;

  @override
  Future<dynamic> delete(String path) => _request(RestMethod.delete, path);

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
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
  }) =>
      _request(RestMethod.put, path, body: body);

  @override
  Future<dynamic> upload(String path, Map<String, File> files) async {
    log(
      'upload $path\n'
      'files: $files',
      name: 'RestApi',
    );

    final formData = FormData();

    formData.files.addAll(
      files.map((key, value) {
        final bytes = value.readAsBytesSync();
        final multipartFile = MultipartFile.fromBytes(bytes);
        return MapEntry(key, multipartFile);
      }).entries,
    );

    return _request(RestMethod.post, path, body: formData);
  }

  Future<dynamic> _request(
    RestMethod method,
    String path, {
    Map<String, dynamic>? query,
    Object? body,
  }) async {
    log(
      '$method ${_dio.options.baseUrl}$path\n'
      'query: $query\n'
      'body: $body',
      name: 'RestApi',
    );

    try {
      final response = await _dio.request<dynamic>(
        path,
        data: body,
        queryParameters: query,
        options: Options(method: method.name),
      );

      return response.data;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          throw BadResponseRestException(
            code: e.response!.statusCode!,
            message: (e.response?.data as Json)['message'] as String? ??
                e.response!.statusMessage!,
          );
        case _:
          throw const NoResponseRestException();
      }
    } on SocketException {
      throw const NoResponseRestException();
    }
  }
}

enum RestMethod {
  delete(name: 'delete'),
  get(name: 'get'),
  post(name: 'post'),
  put(name: 'put');

  const RestMethod({required this.name});

  final String name;
}

abstract class RestApi {
  Future<dynamic> delete(String path);
  Future<dynamic> get(String path, {Map<String, dynamic>? query, Json? body});
  Future<dynamic> post(String path, {Json? body});
  Future<dynamic> put(String path, {Map<String, dynamic>? body});
  Future<dynamic> upload(String path, Map<String, File> files);
}
