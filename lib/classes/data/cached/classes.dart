import 'package:reading/classes/data/repositories/class_repository.dart';
import 'package:reading/classes/domain/models/class.dart';
import 'package:reading/shared/data/paginated_resource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'classes.g.dart';

@riverpod
class MyClasses extends _$MyClasses {
  @override
  Future<PaginatedResource<Class>> build() async {
    return _getMyClasses();
  }

  Future<PaginatedResource<Class>> _getMyClasses() async {
    final classes = await ref
        .read(classRepositoryProvider) //
        .getMyClasses((state.valueOrNull?.currentPage ?? 0) + 1);

    return classes.copyWith(
      data: [...state.valueOrNull?.data ?? [], ...classes.data],
      finished: classes.data.length < classes.perPage,
      loading: false,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await ref.read(classRepositoryProvider).getMyClasses(1));
  }

  Future<void> next() async {
    if (state.requireValue.finished) return;

    state = AsyncData(
      state.requireValue.copyWith(loading: true),
    );

    state = AsyncData(
      await _getMyClasses(),
    );
  }
}
