import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@riverpod
Database database(DatabaseRef ref) {
  return HiveDatabase(ref);
}

@riverpod
Future<BoxBase<dynamic>> hiveBox(
  HiveBoxRef ref,
  Type type, {
  bool lazy = true,
}) async {
  final box = await (lazy
      ? Hive.openLazyBox<dynamic>('${type}s')
      : Hive.openBox<dynamic>('${type}s'));

  ref.onDispose(box.close);

  return box;
}

class HiveDatabase extends Database {
  const HiveDatabase(this.ref);

  final Ref ref;

  @override
  Future<T> getById<T>(int id) async {
    final box = await ref.read(hiveBoxProvider(T).future) as LazyBox<T>;
    final value = await box.get(id);

    if (value == null) {
      throw const NoRowFoundException();
    }

    return value;
  }

  @override
  Future<List<T>> getAll<T>() async {
    final box =
        await ref.read(hiveBoxProvider(T, lazy: false).future) as Box<T>;
    final values = box.values.toList();

    return values;
  }

  @override
  Future<void> update<T>(dynamic id, T value) async {
    final box = await ref.read(hiveBoxProvider(T).future) as LazyBox<T>;
    return box.put(id, value);
  }
}

abstract class Database {
  const Database();

  Future<T> getById<T>(int id);
  Future<List<T>> getAll<T>();
  Future<void> update<T>(dynamic id, T value);
}

sealed class DatabaseException implements Exception {
  const DatabaseException();
}

final class NoRowFoundException extends DatabaseException {
  const NoRowFoundException();
}
