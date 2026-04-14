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
  Future<T> save<T>(T data, [dynamic id]) async {
    final db = ref.read(databaseProvider);

    await (id == null //
        ? db.insert<T>(data)
        : db.update<T>(data, id));

    return data;
  }

  Future<List<T>> saveAll<T>(List<T> data, dynamic Function(T) id) async {
    await ref.read(databaseProvider).updateAll<T>(data, id);
    return data;
  }
}
