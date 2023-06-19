class Book {
  const Book({
    required this.id,
    required this.coverArt,
    required this.title,
    required this.pageCount,
    required this.pagesRead,
  });

  final int id;
  final String coverArt;
  final String title;
  final int pageCount;
  final int pagesRead;
}
