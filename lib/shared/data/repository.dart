import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Repository {
  const Repository(this.ref);

  final Ref ref;
}

mixin OfflineAwareOnlineRepository on Repository {
  Future<void> commitOfflineUpdates();
}
