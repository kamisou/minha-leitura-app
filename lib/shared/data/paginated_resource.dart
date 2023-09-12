import 'package:reading/shared/infrastructure/rest_api.dart';

class PaginatedResource<T> {
  const PaginatedResource({
    required this.data,
    required this.perPage,
    required this.currentPage,
    this.finished = false,
    this.loading = false,
  });

  PaginatedResource.fromJson(
    Json json,
    T Function(Json json) mapper,
  )   : data = (json['data'] as List).cast<Json>().map(mapper).toList(),
        perPage = json['per_page'] as int,
        currentPage = json['current_page'] as int,
        finished = false,
        loading = false;

  final List<T> data;
  final int perPage;
  final int currentPage;
  final bool finished;
  final bool loading;

  PaginatedResource<T> copyWith({
    List<T>? data,
    int? perPage,
    int? currentPage,
    bool? finished,
    bool? loading,
  }) =>
      PaginatedResource(
        data: data ?? this.data,
        perPage: perPage ?? this.perPage,
        currentPage: currentPage ?? this.currentPage,
        finished: finished ?? this.finished,
        loading: loading ?? this.loading,
      );
}
