import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/shared/infrastructure/database.dart';

abstract class Repository {
  const Repository(this.ref);

  final Ref ref;
}

mixin OfflineUpdatePusher on Repository {
  Future<void> pushUpdates();
}

mixin OfflinePersister on Repository {
  T save<T>(T data, dynamic id) {
    ref.read(databaseProvider).update(data, id);
    return data;
  }

  List<T> saveAll<T>(List<T> data, dynamic Function(T) id) {
    ref.read(databaseProvider).updateAll(data, id);
    return data;
  }
}
