import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/common/infrastructure/rest_api.dart';

part 'reading.freezed.dart';
part 'reading.g.dart';

@freezed
class Reading with _$Reading {
  const factory Reading({
    required int pages,
    required DateTime date,
  }) = _Reading;

  factory Reading.fromJson(Json json) => _$ReadingFromJson(json);
}
