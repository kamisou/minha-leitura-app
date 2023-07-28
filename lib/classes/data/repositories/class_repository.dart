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

@riverpod
Future<List<Class>> myClasses(MyClassesRef ref) {
  return ref.watch(classRepositoryProvider).getMyClasses();
}

class OnlineClassRepository extends ClassRepository {
  const OnlineClassRepository(super.ref);

  @override
  Future<List<Class>> getMyClasses() async {
    final classes = await ref
        .read(restApiProvider)
        .get('classes/my')
        .then((response) => (response as List<Json>).map(Class.fromJson))
        .then((classes) => classes.toList());

    ref
        .read(databaseProvider)
        .updateAll(classes, ($class) => $class.id)
        .ignore();

    return classes;
  }

  @override
  Future<void> joinClass(String code) async {
    final $class = await ref
        .read(restApiProvider) //
        .post('classes/$code/join')
        .then((response) => Class.fromJson(response as Json));

    ref.read(databaseProvider).update($class, $class.id).ignore();
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
    throw OnlineOnlyOperationException();
  }
}

abstract class ClassRepository extends Repository {
  const ClassRepository(super.ref);

  Future<List<Class>> getMyClasses();
  Future<void> joinClass(String code);
}
