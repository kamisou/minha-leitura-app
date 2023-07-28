import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_service.g.dart';

@riverpod
RepositoryService repositoryService(RepositoryServiceRef ref) {
  return RepositoryServiceImpl(ref);
}

abstract class RepositoryService {
  void add<T extends Repository>(T online, T offline);
  T call<T extends Repository>();
}

class RepositoryServiceImpl extends RepositoryService {
  RepositoryServiceImpl(this.ref);

  final Ref ref;

  final Map<Type, ({Repository online, Repository offline})> _repos = {};

  @override
  void add<T extends Repository>(T online, T offline) {
    assert(!_repos.containsKey(T), '$T was already registered!');
    _repos[T] = (online: online, offline: offline);
  }

  @override
  T call<T extends Repository>() {
    final repo = _repos[T];

    assert(repo != null, "$T wasn't registered!");

    return ref.read(isConnectedProvider)
        ? repo!.online as T
        : repo!.offline as T;
  }
}

abstract class Repository {
  const Repository(this.ref);

  final Ref ref;
}

abstract class OfflineRepository extends Repository {
  const OfflineRepository(super.ref);
}

abstract class OnlineRepository extends Repository {
  const OnlineRepository(super.ref);
}

mixin OfflineAwareOnlineRepository on OnlineRepository {
  Future<void> commitOfflineUpdates();
}
