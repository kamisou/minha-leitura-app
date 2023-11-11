import 'package:reading/classes/data/cached/classes.dart';
import 'package:reading/classes/domain/models/class.dart';
import 'package:reading/shared/data/cached/connection_status.dart';
import 'package:reading/shared/data/paginated_resource.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'class_repository.g.dart';

@riverpod
ClassRepository classRepository(ClassRepositoryRef ref) {
  return ref.read(isConnectedProvider)
      ? OnlineClassRepository(ref)
      : OfflineClassRepository(ref);
}

class OnlineClassRepository extends ClassRepository {
  const OnlineClassRepository(super.ref);

  @override
  Future<PaginatedResource<Class>> getMyClasses(int page) async {
    final classes = await ref
        .read(restApiProvider) //
        .get('app/enrollment?page=$page&limit=200')
        .then(
          (response) => PaginatedResource.fromJson(
            response as Json,
            Class.fromJson,
          ),
        );

    saveAll(classes.data, ($class) => $class.id).ignore();

    return classes;
  }

  @override
  Future<void> joinClass(String code) async {
    final $class = await ref
        .read(restApiProvider) //
        .post('app/enrollment', body: {'code': code}) //
        .then((response) => (response as Json)['classroom'])
        .then((response) => Class.fromJson(response as Json));

    save<Class>($class, $class.id).ignore();

    return ref.read(myClassesProvider.notifier).refresh();
  }
}

class OfflineClassRepository extends ClassRepository {
  const OfflineClassRepository(super.ref);

  static const pageSize = 200;

  @override
  Future<PaginatedResource<Class>> getMyClasses(int page) async {
    final classes = await ref
        .read(databaseProvider) //
        .getAll<Class>(
          limit: pageSize,
          offset: (page - 1) * pageSize,
        );

    return PaginatedResource(
      currentPage: page,
      data: classes,
      perPage: pageSize,
    );
  }

  @override
  Future<void> joinClass(String code) {
    throw const OnlineOnlyOperationException('joinClass');
  }
}

abstract class ClassRepository extends Repository with OfflinePersister {
  const ClassRepository(super.ref);

  Future<PaginatedResource<Class>> getMyClasses(int page);
  Future<void> joinClass(String code);
}
