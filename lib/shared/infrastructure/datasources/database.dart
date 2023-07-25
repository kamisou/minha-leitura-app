import 'dart:async';

import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@riverpod
Database database(DatabaseRef ref) {
  return Database();
}

class Database {
  Future<T> getById<T>(String collection, int id) async {
    final box = await Hive.openBox<T>(collection);
    final value = box.get(id);

    if (value == null) {
      throw const NoRowFoundException();
    }

    unawaited(box.close());

    return value;
  }

  Future<List<T>> getAll<T>(String collection) async {
    final box = await Hive.openBox<T>(collection);
    final values = box.values.toList();

    unawaited(box.close());

    return values;
  }
}

sealed class DatabaseException implements Exception {
  const DatabaseException();
}

final class NoRowFoundException extends DatabaseException {
  const NoRowFoundException();
}
