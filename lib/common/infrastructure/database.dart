import 'dart:async';

import 'package:hive/hive.dart';
import 'package:reading/common/exceptions/database_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@riverpod
Database database(DatabaseRef ref, String collection) {
  return Database(collection);
}

class Database {
  const Database(this.collection);

  final String collection;

  Future<T> getById<T>(int id) async {
    final box = await Hive.openBox<T>(collection);
    final value = box.get(id);

    if (value == null) {
      throw const NoRowFoundException();
    }

    unawaited(box.close());

    return value;
  }

  Future<List<T>> getAll<T>() async {
    final box = await Hive.openBox<T>(collection);
    final values = box.values.toList();

    unawaited(box.close());

    return values;
  }
}
