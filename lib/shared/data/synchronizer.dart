import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/books/data/repositories/book_note_repository.dart';
import 'package:reading/books/data/repositories/book_rating_repository.dart';
import 'package:reading/books/data/repositories/book_reading_repository.dart';
import 'package:reading/classes/data/cached/classes.dart';
import 'package:reading/classes/domain/models/class.dart';
import 'package:reading/ranking/data/cached/book_ranking.dart';
import 'package:reading/ranking/data/cached/book_reading_ranking.dart';
import 'package:reading/ranking/data/cached/ranking.dart';
import 'package:reading/ranking/data/dtos/ranking_filter_dto.dart';
import 'package:reading/ranking/domain/models/ranking.dart';
import 'package:reading/shared/data/cached/authenticated.dart';
import 'package:reading/shared/data/cached/connection_status.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'synchronizer.g.dart';

@Riverpod(keepAlive: true)
Synchronizer synchronizer(SynchronizerRef ref) {
  final sync = SynchronizerImpl(ref);

  void callback(bool connected) {
    if (connected && !sync.syncing) {
      sync.syncAll();
    }
  }

  ref.read(connectionStatusProvider.notifier).subscribe(callback);
  ref.onDispose(
    () => ref.read(connectionStatusProvider.notifier).unsubscribe(callback),
  );

  return sync;
}

class SynchronizerImpl extends Synchronizer {
  SynchronizerImpl(super.ref);

  bool _syncing = false;
  bool get syncing => _syncing;

  Future<List<Class>> _syncClasses() async {
    await ref.read(myClassesProvider.future);
    while (!ref.read(myClassesProvider).requireValue.finished) {
      await ref.read(myClassesProvider.notifier).next();
    }

    return ref.read(myClassesProvider).requireValue.data;
  }

  Future<void> _syncRankings(List<Class> classes) async {
    for (final type in RankingType.values) {
      if (type == RankingType.global) {
        const filter = RankingFilterDTO(type: RankingType.global);

        await Future.wait([
          ref.read(rankingProvider(filter).future),
          ref.read(bookRankingProvider(filter).future),
          ref.read(bookReadingRankingProvider(filter).future),
        ]);
      } else {
        final schools = <int>[];

        for (final $class in classes) {
          if (type != RankingType.$class &&
              schools.contains($class.school.id)) {
            continue;
          }

          final filter = RankingFilterDTO(type: type, $class: $class);

          await Future.wait([
            ref.read(rankingProvider(filter).future),
            ref.read(bookRankingProvider(filter).future),
            ref.read(bookReadingRankingProvider(filter).future),
          ]);

          schools.add($class.school.id);
        }
      }
    }
  }

  Future<void> _syncBookNotes() async {
    await (ref.read(bookNoteRepositoryProvider) as OnlineBookNoteRepository)
        .pushUpdates();
  }

  Future<void> _syncBookRatings() async {
    await (ref.read(bookRatingRepositoryProvider) as OnlineBookRatingRepository)
        .pushUpdates();
  }

  Future<void> _syncBookReadings() async {
    await (ref.read(bookReadingRepositoryProvider)
            as OnlineBookReadingRepository)
        .pushUpdates();
  }

  @override
  Future<void> syncAll() async {
    if (!ref.read(isConnectedProvider) || !ref.read(isAuthenticatedProvider)) {
      return;
    }

    log('SyncAll', name: 'Synchronizer');

    _syncing = true;

    final classes = await _syncClasses();

    await Future.wait([
      _syncRankings(classes),
      _syncBookNotes(),
      _syncBookRatings(),
      _syncBookReadings(),
    ]);

    _syncing = false;
  }
}

abstract class Synchronizer {
  const Synchronizer(this.ref);

  final Ref ref;

  Future<void> syncAll();
}
