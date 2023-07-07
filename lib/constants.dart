import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'constants.g.dart';

@riverpod
Constants constants(ConstantsRef ref) {
  return const Constants(
    restApiUrl: 'http://192.168.0.169:8002/api',
  );
}

class Constants {
  const Constants({
    required this.restApiUrl,
  });

  final String restApiUrl;
}
