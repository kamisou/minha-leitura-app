import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:reading/shared/exceptions/database_exception.dart';
import 'package:reading/shared/infrastructure/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@riverpod
Database database(DatabaseRef ref) {
  return const HiveDatabase();
}

@riverpod
Database encryptedDatabase(EncryptedDatabaseRef ref) {
  return EncryptedHiveDatabase(ref.read(secureStorageProvider));
}

class HiveDatabase extends Database {
  const HiveDatabase();

  @override
  Future<T> getById<T>(dynamic id) async {
    log('get $T by $id', name: 'Database');

    final box = await _getBox<T>() as LazyBox<T>;
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

    final box = await _getBox<T>(lazy: false) as Box<T>;
    final values = box.values.toList();

    box.close().ignore();

    return values;
  }

  @override
  Future<List<T>> getWhere<T>(bool Function(T value) predicate) async {
    log('get $T where', name: 'Database');

    final box = await _getBox<T>(lazy: false) as Box<T>;
    final values = box.values.where(predicate).toList();

    box.close().ignore();

    return values;
  }

  @override
  Future<int> insert<T>(T value) async {
    log('insert $T: $value', name: 'Database');

    final box = await _getBox<T>() as LazyBox<T>;
    final id = await box.add(value);

    box.close().ignore();

    return id;
  }

  @override
  Future<void> removeById<T>(dynamic id) async {
    log('remove $T by $id', name: 'Database');

    final box = await _getBox<T>() as LazyBox<T>;
    await box.delete(id);

    box.close().ignore();
  }

  @override
  Future<void> removeWhere<T>(
    bool Function(T value) predicate,
    dynamic Function(T value) id,
  ) async {
    log('remove $T where', name: 'Database');

    final box = await _getBox<T>(lazy: false) as Box<T>;
    final ids = box.values.where(predicate).map(id);

    await box.deleteAll(ids);

    box.close().ignore();
  }

  @override
  Future<void> update<T>(T value, dynamic id) async {
    log('update $T: $value ($id)', name: 'Database');

    final box = await _getBox<T>() as LazyBox<T>;
    await box.put(id, value);

    box.close().ignore();
  }

  @override
  Future<void> updateAll<T>(
    Iterable<T> values,
    dynamic Function(T value) id,
  ) async {
    log('update all $T', name: 'Database');

    final box = await _getBox<T>() as LazyBox<T>;
    await box.putAll({
      for (final value in values) //
        id(value): value,
    });

    box.close().ignore();
  }

  Future<BoxBase<T>> _getBox<T>({bool lazy = true}) async {
    if (lazy) {
      return Hive.openLazyBox<T>(T.toString());
    } else {
      return Hive.openBox<T>(T.toString());
    }
  }
}

class EncryptedHiveDatabase extends HiveDatabase {
  const EncryptedHiveDatabase(this.secureStorage);

  final SecureStorage secureStorage;

  @override
  Future<BoxBase<T>> _getBox<T>({bool lazy = true}) async {
    var key = await secureStorage.read('hive_key');

    if (key == null) {
      final newKey = base64Encode(Hive.generateSecureKey());
      await secureStorage.write('hive_key', newKey);
      key = newKey;
    }

    final cipher = HiveAesCipher(base64Decode(key));

    if (lazy) {
      return Hive.openLazyBox<T>(T.toString(), encryptionCipher: cipher);
    } else {
      return Hive.openBox<T>(T.toString(), encryptionCipher: cipher);
    }
  }
}

abstract class Database {
  const Database();

  Future<T> getById<T>(dynamic id);
  Future<List<T>> getAll<T>();
  Future<List<T>> getWhere<T>(bool Function(T value) predicate);
  Future<int> insert<T>(T value);
  Future<void> removeById<T>(dynamic id);
  Future<void> removeWhere<T>(
    bool Function(T value) predicate,
    dynamic Function(T value) id,
  );
  Future<void> update<T>(T value, dynamic id);
  Future<void> updateAll<T>(Iterable<T> values, dynamic Function(T value) id);
}
