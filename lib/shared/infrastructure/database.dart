import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/exceptions/database_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@Riverpod(keepAlive: true)
Database database(DatabaseRef ref) {
  return HiveDatabase(ref);
}

class HiveDatabase extends Database {
  const HiveDatabase(this.ref);

  final Ref ref;

  @override
  Future<T> getById<T>(dynamic id) async {
    log('get $T by $id', name: 'Database');

    final box = await Hive.openLazyBox<T>(T.toString());
    final value = await box.get(id);

    box.close().ignore();

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

    box.close().ignore();

    return values;
  }

  @override
  Future<List<T>> getWhere<T>(bool Function(T value) predicate) async {
    log('get $T where', name: 'Database');

    final box = await Hive.openBox<T>(T.toString());
    final values = box.values.where(predicate).toList();

    box.close().ignore();

    return values;
  }

  @override
  Future<int> insert<T>(T value) async {
    log('insert $T: $value', name: 'Database');

    final box = await Hive.openLazyBox<T>(T.toString());
    final id = await box.add(value);

    box.close().ignore();

    return id;
  }

  @override
  Future<void> removeById<T>(dynamic id) async {
    log('remove $T by $id', name: 'Database');

    final box = await Hive.openLazyBox<T>(T.toString());
    await box.delete(id);

    box.close().ignore();
  }

  @override
  Future<void> update<T>(T value, dynamic id) async {
    log('update $T: $value ($id)', name: 'Database');

    final box = await Hive.openLazyBox<T>(T.toString());
    await box.put(id, value);

    box.close().ignore();
  }

  @override
  Future<void> updateAll<T>(
    Iterable<T> values,
    dynamic Function(T value) id,
  ) async {
    log('update all $T', name: 'Database');

    final box = await Hive.openLazyBox<T>(T.toString());
    await box.putAll({
      for (final value in values) //
        id(value): value,
    });

    box.close().ignore();
  }
}

abstract class Database {
  const Database();

  Future<T> getById<T>(dynamic id);
  Future<List<T>> getAll<T>();
  Future<List<T>> getWhere<T>(bool Function(T value) predicate);
  Future<int> insert<T>(T value);
  Future<void> removeById<T>(dynamic id);
  Future<void> update<T>(T value, dynamic id);
  Future<void> updateAll<T>(Iterable<T> values, dynamic Function(T value) id);
}
