import 'dart:async';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

@riverpod
SecureStorage secureStorage(SecureStorageRef ref) {
  return SecureStorageImpl();
}

class SecureStorageImpl extends SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<String?> read(String key) {
    log('read $key', name: 'SecureStorage');
    return _storage.read(key: key);
  }

  @override
  Future<void> write(String key, String? value) {
    log('write $key: $value', name: 'SecureStorage');
    return _storage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) {
    log('delete $key', name: 'SecureStorage');
    return _storage.delete(key: key);
  }
}

abstract class SecureStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String? value);
  Future<void> delete(String key);
}
