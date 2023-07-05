import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/classes/domain/models/class.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'class_repository.g.dart';

@riverpod
ClassRepository classRepository(ClassRepositoryRef ref) {
  return ClassRepository(ref);
}

@riverpod
Future<List<Class>> myClasses(MyClassesRef ref) {
  return ref.watch(classRepositoryProvider).getMyClasses();
}

class ClassRepository {
  const ClassRepository(this.ref);

  final Ref ref;

  Future<List<Class>> getMyClasses() async {
    // final dynamic response = ref.read(restApiProvider).get('/user/books');
    // return (response as List).cast<Json>().map(Class.fromJson).toList();

    return const [
      Class(
        id: 1,
        code: '21MWTA',
        name: '3o Ano MA',
      ),
      Class(
        id: 2,
        code: 'X1TUR6',
        name: 'Robótica',
      ),
    ];
  }
}