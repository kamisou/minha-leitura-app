import 'package:reading/shared/infrastructure/rest_api.dart';

class PaginatedResource<T> {
  const PaginatedResource({
    required this.data,
    required this.perPage,
    required this.currentPage,
  });

  PaginatedResource.fromJson(Json json, T Function(Json json) mapper)
      : data = (json['data'] as List).cast<Json>().map(mapper).toList(),
        perPage = json['per_page'] as int,
        currentPage = json['current_page'] as int;

  final List<T> data;
  final int perPage;
  final int currentPage;

  PaginatedResource<T> copyWith({
    List<T>? data,
    int? perPage,
    int? currentPage,
  }) =>
      PaginatedResource(
        data: data ?? this.data,
        perPage: perPage ?? this.perPage,
        currentPage: currentPage ?? this.currentPage,
      );
}
