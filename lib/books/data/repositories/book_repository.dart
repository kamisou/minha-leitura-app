import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/authentication/domain/models/user.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/books/domain/models/book_reading.dart';
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
            'https://s3-alpha-sig.figma.com/img/fc51/9370/48b40648284f72d5ba23eb7f53b20da8?Expires=1689552000&Signature=d9gtAuuYv23Q98uvBdAe9LT3SExvvBaHmd5XgKJQXgYxRIRiqJKgH6W4uOFNMs1fijGzP7Blow6OwqrG-5H5kaYa4UbX~B0DjtfBg2SuTN8nYX4njgq4ur3msyrmcwlHXNggPRkNs8MUI95KKTDMQMOqHMyZwwE2y-HbDrA56wPBJ0LtwBpihuwsHxHgEjQUtJ63Tr7Tc13Tnh2MEk0zMjw0Q05zFHcBPvqz5RxNxBf3beAYD85GaIMLeHKC9uMjR2MMHDjNXHkJlX0792FBIJNS7m2yFx9w5O7ADp9rlLZcZ9Au-dTpBc4znP6cbLHtQWWnji2xIYCo4q6puXifYw__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
        title: 'Alice no País das Maravilhas',
        author: 'Lewis Carroll',
        pageCount: 278,
        pagesRead: 12,
      ),
      Book(
        id: 2,
        coverArt:
            'https://s3-alpha-sig.figma.com/img/9dfb/7245/929efadae64ddbcebcc7571b22cbb0df?Expires=1689552000&Signature=JOLn1Jgkk61gSMaGCpbKQZMJyxPh-B1hW2sWkUoluHiGVEflvqyvsVJ2vWgD6cY6A4KV3KrrCZRr~JYRRSUrh~FK3t5YBHwSAE11yG2s~cIjfhzqsfuY2a-SEDI17MpgKR-GgwfYJ6mlGclRVEcZe5qzhMeVoD5~UF8QjVo5FjOkuldwYLTLTQzKdrvJUMkErJr-HYgjf7200hCnZOHx0Z0aoEHC5NVnsGAWKM~JqcO52tuWObV9z-0zBEohL0ZCiiM-3AKkhgLCdj-JPNgAeCdZnElPQLBxeeKX08fPATHUlB7gkVnezH42pqk4M0YHQFD5kL0xMi4IjYpHKLnXSA__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
        title: 'O Iluminado',
        author: 'Stephen King',
        pageCount: 190,
        pagesRead: 142,
      ),
      Book(
        id: 3,
        coverArt:
            'https://s3-alpha-sig.figma.com/img/0945/92c4/c342a44fe57ffa61249aa175384402fc?Expires=1689552000&Signature=QPJ7Dvp9MUInw7on8JAlwshmTyqbL750Tepfi085zxEzfMA5SlZZg0YtDL74cvm-mkZjanmM4TA9c8SfIPNrVfTNkZMAmRiHPEESypxkGg-MrirsbXrD~jL-VLAoeh-V2nCfowH9cwmpsTQXYA~bmML98f3GbnF6mbPnS5wLVevsKALSlgSF~1QuICsyuabJ2KnIA-8WoKWvRSpgstd0IseoCDiIPEqLjXrNb1X~KAgKFY7B4zW9D4bUuYh9dHD4i~zMedAlnAokdh3ZMfhmtHRwmt10qS3FdX~Wa22Nxljhr3Bu8Wk2RwWvokniE2xoJFaRyYA3qfm-mjUKJAnxQg__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
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
}
