import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'configuration.g.dart';

@riverpod
Configuration config(ConfigRef ref) {
  return const Configuration(
    restApiUrl: 'http://192.168.0.169:8002/api',
    restApiAuthScheme: 'Bearer',
  );
}

class Configuration {
  const Configuration({
    required this.restApiUrl,
    required this.restApiAuthScheme,
  });

  final String restApiUrl;
  final String restApiAuthScheme;
}
