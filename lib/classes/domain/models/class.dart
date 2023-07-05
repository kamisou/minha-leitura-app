import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/common/infrastructure/rest_api.dart';

part 'class.freezed.dart';
part 'class.g.dart';

@freezed
class Class with _$Class {
  const factory Class({
    required int id,
    required String code,
    required String name,
  }) = _Class;

  factory Class.fromJson(Json json) => _$ClassFromJson(json);
}
