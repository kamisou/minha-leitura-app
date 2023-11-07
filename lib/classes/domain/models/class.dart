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
    @HiveField(3) required School school,
  }) = _Class;

  factory Class.fromJson(Json json) => _$ClassFromJson(json);
}

@freezed
@HiveType(typeId: 18)
class School with _$School {
  const factory School({
    @HiveField(0) required String name,
    @HiveField(1) required String city,
    @HiveField(2) required String state,
    @HiveField(3) required String country,
  }) = _School;

  factory School.fromJson(Json json) => _$SchoolFromJson(json);
}
