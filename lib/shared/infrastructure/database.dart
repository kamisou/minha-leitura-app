import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/exceptions/database_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@riverpod
Database database(DatabaseRef ref) {
  return HiveDatabase(ref);
}

class HiveDatabase extends Database {
  const HiveDatabase(this.ref);

  final Ref ref;

  @override
  Future<T> getById<T>(int id) async {
    log('get $T by $id', name: 'Database');

    final box = await Hive.openLazyBox<T>(T.toString());
    final value = await box.get(id);

    if (value == null) {
      throw const NoRowFoundException();
    }

    return value;
  }

  @override
  Future<List<T>> getAll<T>() async {
    log('get all $T', name: 'Database');

    final box = await Hive.openBox<T>(T.toString());
    final values = box.values.toList();

    return values;
  }

  @override
  Future<List<T>> getWhere<T>(bool Function(T value) predicate) async {
    log('get $T where', name: 'Database');

    final box = await Hive.openBox<T>(T.toString());
    final values = box.values.where(predicate).toList();

    return values;
  }

  @override
  Future<int> insert<T>(T value) async {
    log('insert $T: $value', name: 'Database');

    final box = await Hive.openLazyBox<T>(T.toString());

    return box.add(value);
  }

  @override
  Future<void> update<T>(T value, dynamic id) async {
    log('update $T: $value ($id)', name: 'Database');

    final box = await Hive.openLazyBox<T>(T.toString());

    return box.put(id, value);
  }

  @override
  Future<void> updateAll<T>(
    Iterable<T> values,
    dynamic Function(T value) id,
  ) async {
    log('update all $T', name: 'Database');

    final box = await Hive.openLazyBox<T>(T.toString());

    return box.putAll(
      {
        for (final value in values) //
          id(value): value,
      },
    );
  }
}

abstract class Database {
  const Database();

  Future<T> getById<T>(int id);
  Future<List<T>> getAll<T>();
  Future<List<T>> getWhere<T>(bool Function(T value) predicate);
  Future<int> insert<T>(T value);
  Future<void> update<T>(T value, dynamic id);
  Future<void> updateAll<T>(Iterable<T> values, dynamic Function(T value) id);
}
