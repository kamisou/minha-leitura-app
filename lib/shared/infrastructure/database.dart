import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reading/achievements/domain/models/achievement.dart';
import 'package:reading/authentication/domain/domain/token.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/books/domain/models/book_rating.dart';
import 'package:reading/books/domain/models/book_reading.dart';
import 'package:reading/classes/domain/models/class.dart';
import 'package:reading/profile/domain/models/user.dart';
import 'package:reading/profile/domain/models/user_profile.dart';
import 'package:reading/ranking/domain/models/book_ranking.dart';
import 'package:reading/ranking/domain/models/ranking.dart';
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
  Future<void> initialize() async {
    await Hive.initFlutter('hive');
    Hive
      ..registerAdapter(TokenAdapter())
      ..registerAdapter(UserAdapter())
      ..registerAdapter(UserProfileAdapter())
      ..registerAdapter(ClassAdapter())
      ..registerAdapter(BookAdapter())
      ..registerAdapter(BookDetailsAdapter())
      ..registerAdapter(BookReadingAdapter())
      ..registerAdapter(BookRatingAdapter())
      ..registerAdapter(BookNoteAdapter())
      ..registerAdapter(BookStatusAdapter())
      ..registerAdapter(AchievementCategoryAdapter())
      ..registerAdapter(AchievementAdapter())
      ..registerAdapter(RankingAdapter())
      ..registerAdapter(RankingSpotAdapter())
      ..registerAdapter(SchoolAdapter())
      ..registerAdapter(BookRankingAdapter())
      ..registerAdapter(BookRankingSpotAdapter());
  }

  @override
  Future<T?> getById<T>(dynamic id) async {
    log('get $T by $id', name: 'Database');

    final box = await _getBox<T>();
    final value = box.get(id);

    return value;
  }

  @override
  Future<List<T>> getAll<T>({int? limit, int? offset}) async {
    log('get all $T', name: 'Database');

    final box = await _getBox<T>();
    var values = box.values.skip(offset ?? 0);

    if (limit != null) {
      values = values.take(limit);
    }

    return values.toList();
  }

  @override
  Future<List<T>> getWhere<T>(
    bool Function(T value) predicate, {
    int? limit,
    int? offset,
  }) async {
    log('get $T where', name: 'Database');

    final box = await _getBox<T>();
    var values = box.values.where(predicate).skip(offset ?? 0);

    if (limit != null) {
      values = values.take(limit);
    }

    return values.toList();
  }

  @override
  Future<int> insert<T>(T value) async {
    log('insert $T: $value', name: 'Database');

    final box = await _getBox<T>();
    final id = await box.add(value);

    return id;
  }

  @override
  Future<void> removeById<T>(dynamic id) async {
    log('remove $T by $id', name: 'Database');

    final box = await _getBox<T>();
    await box.delete(id);
  }

  @override
  Future<void> removeWhere<T>(
    bool Function(T value) predicate,
    dynamic Function(T value) id,
  ) async {
    log('remove $T where', name: 'Database');

    final box = await _getBox<T>();
    final ids = box.values.where(predicate).map(id);

    await box.deleteAll(ids);
  }

  @override
  Future<void> update<T>(T value, dynamic id) async {
    log('update $T: ($id)', name: 'Database');

    final box = await _getBox<T>();
    await box.put(id, value);
  }

  @override
  Future<void> updateAll<T>(
    Iterable<T> values,
    dynamic Function(T value) id,
  ) async {
    log('update all $T', name: 'Database');

    final box = await _getBox<T>();
    await box.putAll({
      for (final value in values) //
        id(value): value,
    });
  }

  @override
  Future<void> wipe() async {
    log('wiping Hive database', name: 'Database');

    final appDocs = await getApplicationDocumentsDirectory();
    final hive = Directory('${appDocs.path}/hive');

    await hive.delete(recursive: true);
  }

  FutureOr<Box<T>> _getBox<T>() {
    final boxName = T.toString();

    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }

    return Hive.openBox<T>(boxName);
  }
}

class EncryptedHiveDatabase extends HiveDatabase {
  const EncryptedHiveDatabase(this.secureStorage);

  final SecureStorage secureStorage;

  @override
  Future<Box<T>> _getBox<T>() async {
    var key = await secureStorage.read('hive_key');

    if (key == null) {
      final newKey = base64Encode(Hive.generateSecureKey());
      await secureStorage.write('hive_key', newKey);
      key = newKey;
    }

    final cipher = HiveAesCipher(base64Decode(key));

    final boxName = T.toString();

    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }

    return Hive.openBox<T>(boxName, encryptionCipher: cipher);
  }
}

abstract class Database {
  const Database();

  Future<void> initialize();
  Future<T?> getById<T>(dynamic id);
  Future<List<T>> getAll<T>({int? offset, int? limit});
  Future<List<T>> getWhere<T>(
    bool Function(T value) predicate, {
    int? limit,
    int? offset,
  });
  Future<int> insert<T>(T value);
  Future<void> removeById<T>(dynamic id);
  Future<void> removeWhere<T>(
    bool Function(T value) predicate,
    dynamic Function(T value) id,
  );
  Future<void> update<T>(T value, dynamic id);
  Future<void> updateAll<T>(Iterable<T> values, dynamic Function(T value) id);
  Future<void> wipe();
}
