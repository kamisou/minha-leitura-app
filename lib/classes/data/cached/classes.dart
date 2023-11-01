import 'package:reading/classes/data/repositories/class_repository.dart';
import 'package:reading/classes/domain/models/class.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'classes.g.dart';

@riverpod
Future<List<Class>> myClasses(MyClassesRef ref) {
  return ref.watch(classRepositoryProvider).getMyClasses();
}
