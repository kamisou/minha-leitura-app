import 'dart:async';

import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@riverpod
Database database(DatabaseRef ref) {
  return Database();
}

class Database {
  Future<T> getById<T>(int id) async {
    final box = await Hive.openLazyBox<T>(T.toString());
    final value = await box.get(id);

    if (value == null) {
      throw const NoRowFoundException();
    }

    box.close().ignore();

    return value;
  }

  Future<List<T>> getAll<T>() async {
    final box = await Hive.openBox<T>(T.toString());
    final values = box.values.toList();

    box.close().ignore();

    return values;
  }

  Future<void> update<T>(dynamic id, T value) async {
    final box = await Hive.openLazyBox<T>(T.toString());
    await box.put(id, value);

    box.close().ignore();
  }
}

sealed class DatabaseException implements Exception {
  const DatabaseException();
}

final class NoRowFoundException extends DatabaseException {
  const NoRowFoundException();
}
