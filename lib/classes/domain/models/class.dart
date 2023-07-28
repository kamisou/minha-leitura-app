import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'class.freezed.dart';
part 'class.g.dart';

@freezed
@HiveType(typeId: 4)
class Class with _$Class {
  const factory Class({
    @HiveField(0) required int id,
    @HiveField(1) required String code,
    @HiveField(2) required String name,
  }) = _Class;

  factory Class.fromJson(Json json) => _$ClassFromJson(json);
}
