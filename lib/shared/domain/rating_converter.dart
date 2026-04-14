import 'package:json_annotation/json_annotation.dart';

class RatingConverter implements JsonConverter<double, dynamic> {
  const RatingConverter();

  @override
  double fromJson(dynamic json) => switch (json) {
        String() => double.parse(json),
        num() => json.toDouble(),
        _ => throw UnimplementedError(),
      };

  @override
  dynamic toJson(double object) => object.toStringAsFixed(1);
}
