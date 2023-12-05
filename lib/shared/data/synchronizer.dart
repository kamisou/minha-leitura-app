import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/books/data/repositories/book_note_repository.dart';
import 'package:reading/books/data/repositories/book_rating_repository.dart';
import 'package:reading/books/data/repositories/book_reading_repository.dart';
import 'package:reading/classes/data/cached/classes.dart';
import 'package:reading/ranking/data/cached/book_ranking.dart';
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

  Future<void> _syncClasses() async {
    await ref.read(myClassesProvider.future);
    while (!ref.read(myClassesProvider).requireValue.finished) {
      await ref.read(myClassesProvider.notifier).next();
    }
  }

  Future<void> _syncRankings() async {
    final schools = <int>[];

    for (final $class in ref.read(myClassesProvider).requireValue.data) {
      for (final type in RankingType.values) {
        if (type == RankingType.global ||
            (type != RankingType.$class &&
                schools.contains($class.school.id))) {
          continue;
        }

        await ref.read(
          rankingProvider(
            RankingFilterDTO(
              type: type,
              $class: $class,
            ),
          ).future,
        );
      }

      schools.add($class.school.id);
    }

    await ref.read(
      rankingProvider(const RankingFilterDTO(type: RankingType.global)).future,
    );
  }

  Future<void> _syncBookRankings() async {
    final schools = <int>[];

    for (final $class in ref.read(myClassesProvider).requireValue.data) {
      for (final type in RankingType.values) {
        if (type == RankingType.global ||
            (type != RankingType.$class &&
                schools.contains($class.school.id))) {
          continue;
        }

        await ref.read(
          bookRankingProvider(
            RankingFilterDTO(
              type: type,
              $class: $class,
            ),
          ).future,
        );

        schools.add($class.school.id);
      }
    }

    await ref.read(
      bookRankingProvider(const RankingFilterDTO(type: RankingType.global))
          .future,
    );
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

    await _syncClasses();

    await Future.wait([
      _syncRankings(),
      _syncBookRankings(),
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
