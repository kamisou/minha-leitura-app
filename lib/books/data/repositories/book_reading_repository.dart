import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/books/data/cached/books.dart';
import 'package:reading/books/data/dtos/new_reading_dto.dart';
import 'package:reading/books/domain/models/book_reading.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/shared/data/cached/connection_status.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_reading_repository.g.dart';

@riverpod
BookReadingRepository bookReadingRepository(BookReadingRepositoryRef ref) {
  return ref.read(isConnectedProvider)
      ? OnlineBookReadingRepository(ref)
      : OfflineBookReadingRepository(ref);
}

class OnlineBookReadingRepository extends BookReadingRepository
    with OfflineUpdatePusher {
  OnlineBookReadingRepository(super.ref) {
    pushUpdates();
  }

  @override
  Future<void> updateReading(int bookId, NewReadingDTO data) async {
    final reading = await ref
        .read(restApiProvider)
        .put('app/reading/$bookId', body: data.toJson())
        .then((response) => BookReading.fromJson(response as Json));

    await save<BookReading>(reading, reading.id);

    return super.updateReading(bookId, data);
  }

  @override
  Future<void> pushUpdates() async {
    final readings = await ref
        .read(databaseProvider) //
        .getAll<BookReading>();

    for (final reading in readings) {
      final data = NewReadingDTO(
        page: Pages(reading.page),
      );

      await updateReading(reading.bookId, data);

      reading.delete().ignore();
    }
  }
}

class OfflineBookReadingRepository extends BookReadingRepository {
  const OfflineBookReadingRepository(super.ref);

  @override
  Future<void> updateReading(int bookId, NewReadingDTO data) async {
    final reading = BookReading(
      page: data.page.value!,
      bookId: bookId,
    );

    await save<BookReading>(reading);

    return super.updateReading(bookId, data);
  }
}

abstract class BookReadingRepository extends Repository with OfflinePersister {
  const BookReadingRepository(super.ref);

  @mustCallSuper
  @mustBeOverridden
  Future<void> updateReading(int bookId, NewReadingDTO data) async {
    return ref.read(myBooksProvider.notifier).refresh();
  }
}
