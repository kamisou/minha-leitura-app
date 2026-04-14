import 'package:reading/shared/infrastructure/rest_api.dart';

class TokenDTO {
  const TokenDTO({
    required this.accessToken,
  });

  TokenDTO.fromJson(Json json)
      : //
        accessToken = json['token'] as String;

  final String accessToken;
}
