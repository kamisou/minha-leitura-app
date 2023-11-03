import 'package:reading/classes/data/cached/classes.dart';
import 'package:reading/classes/domain/models/class.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
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
  Future<List<Class>> getMyClasses() async {
    final classes = await ref
        .read(restApiProvider)
        .get('app/enrollment')
        .then((response) => (response as Json)['data'])
        .then((response) => (response as List).cast<Json>())
        .then(
          (list) => list.map((json) {
            // ignore: avoid_dynamic_calls
            json['school_name'] = json['school']['name'];
            return Class.fromJson(json);
          }),
        )
        .then((classes) => classes.toList());

    saveAll(classes, ($class) => $class.id).ignore();

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

    ref.invalidate(myClassesProvider);
  }
}

class OfflineClassRepository extends ClassRepository {
  const OfflineClassRepository(super.ref);

  @override
  Future<List<Class>> getMyClasses() {
    return ref.read(databaseProvider).getAll<Class>();
  }

  @override
  Future<void> joinClass(String code) {
    throw const OnlineOnlyOperationException('joinClass');
  }
}

abstract class ClassRepository extends Repository with OfflinePersister {
  const ClassRepository(super.ref);

  Future<List<Class>> getMyClasses();
  Future<void> joinClass(String code);
}
