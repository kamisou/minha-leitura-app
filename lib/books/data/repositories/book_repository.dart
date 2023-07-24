import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/books/data/dtos/new_note_dto.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/books/domain/models/book_reading.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/common/infrastructure/rest_api.dart';
import 'package:reading/profile/domain/models/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_repository.g.dart';

@riverpod
BookRepository bookRepository(BookRepositoryRef ref) {
  return BookRepository(ref);
}

@riverpod
Future<List<Book>> myBooks(MyBooksRef ref) {
  return ref.watch(bookRepositoryProvider).getMyBooks();
}

@riverpod
Future<BookDetails> bookDetails(BookDetailsRef ref, int bookId) {
  return ref.watch(bookRepositoryProvider).getBookDetails(bookId);
}

@riverpod
Future<List<BookNote>> bookNotes(BookNotesRef ref, int bookId) {
  return ref.watch(bookRepositoryProvider).getBookNotes(bookId);
}

@riverpod
Future<List<BookReading>> bookReadings(BookReadingsRef ref, int bookId) {
  return ref.watch(bookRepositoryProvider).getBookReadings(bookId);
}

class BookRepository {
  const BookRepository(this.ref);

  final Ref ref;

  Future<List<Book>> getMyBooks() async {
    // final dynamic response = await ref.read(restApiProvider).get('/user/books');
    // return (response as List).cast<Json>().map(Book.fromJson).toList();

    return const [
      Book(
        id: 1,
        coverArt:
            'https://s3-alpha-sig.figma.com/img/fc51/9370/48b40648284f72d5ba23eb7f53b20da8?Expires=1690761600&Signature=QiADSdNuPkbyJqAkP46yYdgkWj19XGUyn9ieeoibzunEzfF~vIKTdwewMjfb21yVJ9Gq2FKSoEFm~D0BxwoJEfz-9MVumNu64plDQfDL-nDLiVAAW7Zm69i7nG0-eK6uJZbTycZcH6rF0tWQiA2-8~xSmECNoWk-mT7-DL55BlcR0f6dzkxK0QjmJcs~vUKMmoKfO70dhP2nV0GYdpSYvsghBfxwZ40lADVTPwTwSK2fBPz4VbP~p5FPb7dz8HLAPJlR9ZlWhCmydjdVyUL5Oo-MiBe~S2U2iU1pZBP-4blVZSDTJ-yuQ5W94vgkQuX~CoT0yy4No3B-7q49MKwQGA__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
        title: 'Alice no País das Maravilhas',
        author: 'Lewis Carroll',
        pageCount: 278,
        pagesRead: 12,
      ),
      Book(
        id: 2,
        coverArt:
            'https://s3-alpha-sig.figma.com/img/9dfb/7245/929efadae64ddbcebcc7571b22cbb0df?Expires=1690761600&Signature=b2~fTAwUPuJsjM1N4iH5xkrPA2TdbioLU~eWKrtRd-uEOgGx8rCXSkRgtvUNND1md3qVJhoIDX6aZx33umTYQOsyTN6jiKerNy3UZ1VkFSZh3xEk5-frLTylmLXrtAIVLO15kwozbTzLkeGgyCqX6avImGwEQbEJ1r-lVaOmuZ9NGPahAmn6~l5Y5hkTuGsyXdECON6w-FOWKb9OzaKBIUi2VrIgWxf~Sz-HvPzl-WFluKGTYOVUgu4naZMlzFmJeRF57eiAaTPAeKD-mCkLGsYFd6R1TtSzW23J0~eMjeGg-obJGJx3s4~lvCUIQZg5sK2dQCkvm4EniXdqLE8d8w__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
        title: 'O Iluminado',
        author: 'Stephen King',
        pageCount: 190,
        pagesRead: 142,
      ),
      Book(
        id: 3,
        coverArt:
            'https://s3-alpha-sig.figma.com/img/0945/92c4/c342a44fe57ffa61249aa175384402fc?Expires=1690761600&Signature=f-VogXfxA3TG4v88~y7BFLF-z9UpsPujoSYe0HnBNeYG9OdA3dHscnT9MqyIwJh9TC6AZNJotTBBqNx4jS7BzVA3pqWfBTdwuNlsQf6s2y8Igv7EsMyAlQ7PavCylDYgZpb8CVl1rp6EEF~~wA5WhcCnla9HhRmn7PEV3Cp1GBuWp6w7IjjSQl8Bx~jLtcp5qGNsa4cFQmJoWgrUfzM6RanLuh3h5IgVRsK4S6MpP7NoSVpM386JnTEpdjwYk065yhs3MBZbybDFBtEeknt71OIRkRER5EfxgJQWgnnu9UY~6MVN1DOpHvIPkrsqmHOfSxThjukL2MVu4ugadPELHw__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
        title: 'Clube da Luta',
        author: 'Chuck Palahniuk',
        pageCount: 210,
        pagesRead: 87,
      ),
    ];
  }

  Future<BookDetails> getBookDetails(int bookId) async {
    // final dynamic response =
    //     await ref.read(restApiProvider).get('/book/$bookId');
    // return BookDetails.fromJson(response as Json);

    return BookDetails(
      id: 1,
      pageCount: 278,
      pagesRead: 72,
      currentPage: 36,
      dailyPageGoal: 10,
      started: DateTime.parse('2021-02-10'),
    );
  }

  Future<List<BookNote>> getBookNotes(int bookId) async {
    // final dynamic response =
    //     await ref.read(restApiProvider).get('/book/$bookId/notes');
    // return (response as List).cast<Json>().map(BookNote.fromJson).toList();

    return [
      BookNote(
        title: 'Reflexão',
        description:
            'Ipsum sea dolore clita magna. Sit et dolor sit in invidunt lorem'
            ' labore. Est invidunt at dolor tempor nonumy sit dolores ullamco'
            'rper commodo. Lorem et tation ipsum eos dolor magna sanctus tinc'
            'idunt vulputate erat lorem dolor sea dolore rebum. Justo invidun'
            't gubergren diam ipsum dolores erat no lorem. Accusam eos ipsum '
            'diam est ea lorem ipsum minim. Lorem diam nihil est ipsum elitr '
            'ipsum voluptua. Nibh nonumy erat dolor lorem ipsum et. Lorem dia'
            'm tempor ut sadipscing eos consequat kasd et diam ea vero diam i'
            'psum gubergren no. Vel suscipit vero est tation eos duo nonumy e'
            't sed. Et dolor et elitr et kasd sit velit rebum. Sanctus ut ea '
            'sadipscing enim. Labore dolor at at nihil labore erat quis sea i'
            'n et veniam et erat. Vulputate ex diam nonumy liber invidunt et '
            'dolor lorem dolor et. Dignissim erat lorem eum rebum dolor accus'
            'am. Diam ipsum clita sit et ea sea. Amet vulputate tation et iri'
            'ure est ut est takimata est sea. Kasd amet lorem diam. Mazim eli'
            'tr amet est sadipscing nibh rebum.',
        author: const User(name: 'Guilherme'),
        createdAt: DateTime.parse('2022-09-26T15:26:30.000Z'),
        responses: [
          BookNote(
            title: 'Título XPTO',
            description: 'Vel et sit dolor sit stet. Hendrerit volutpat autem'
                ' sea justo ut et quis lorem. Ut nonumy accusam nulla doming '
                'id et diam diam voluptua no dolor facilisi.',
            author: const User(name: 'Fulano de Tal'),
            createdAt: DateTime.parse('2022-09-26T15:26:30.000Z'),
          ),
        ],
      ),
    ];
  }

  Future<List<BookReading>> getBookReadings(int bookId) async {
    // final dynamic response =
    //     await ref.read(restApiProvider).get('/book/$bookId/readings');
    // return (response as List).cast<Json>().map(BookNote.fromJson).toList();

    return [
      BookReading(
        pages: 22,
        date: DateTime.parse('2021-02-10T18:24:00.000Z'),
      ),
      BookReading(
        pages: 9,
        date: DateTime.parse('2021-02-09T19:11:00.000Z'),
      ),
      BookReading(
        pages: 4,
        date: DateTime.parse('2021-02-08T20:27:00.000Z'),
      ),
    ];
  }

  Future<void> addReading(int bookId, Pages pages) async {
    await ref
        .read(restApiProvider)
        .post('/book/$bookId/readings', body: {'pages': pages.value});

    ref.invalidate(bookDetailsProvider(bookId));
  }

  Future<void> addNote(int bookId, NewNoteDTO note) async {
    await ref
        .read(restApiProvider)
        .post('/book/$bookId/notes', body: note.toJson());

    ref.invalidate(bookDetailsProvider(bookId));
  }
}
