import 'package:json_annotation/json_annotation.dart';

class LocalDateTimeConverter implements JsonConverter<DateTime, String> {
  const LocalDateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toLocal();

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}
