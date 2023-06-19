import 'package:flutter/material.dart';

import '../../domain/models/book.dart';
import 'book_carrousel_content.dart';
import 'greeting_content.dart';

class BookHomePage extends StatelessWidget {
  const BookHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const books = [
      Book(
        id: 1,
        coverArt:
            'https://s3-alpha-sig.figma.com/img/fc51/9370/48b40648284f72d5ba23eb7f53b20da8?Expires=1688342400&Signature=elyIftyOmme83NDw-KdeqZ~6aYK87cURb2LXkZI8ohAu~UohGLkty2yYjWCeXPLB5iFKsOcwRlf0UvQ5oiNmcp3RVDfo2iky1sPq1MAfB-n~ivcmIDBQEjkAznkBOMK7GwlgqXyZOaAtVt8rGjW9HBpCyt45lOZuPYMvFsJ0jFvOXHAbiypd99DcgRsOhvXmUOHEtA5jCiUuaxPa0qcH9gYWyBjP4Vj4JH2Z3yxwPT--XbpHk1qWTW8LsmExcbxDZTlyIufxyE0znnX8YWfZ~gDGINNaAH5OPrBK0759DfzzwfYT008u1vJSvyhdevw9rFAwz045sFf-VLlw3xrsJg__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
        title: 'Alice no País das Maravilhas',
        pageCount: 278,
        pagesRead: 12,
      ),
      Book(
        id: 2,
        coverArt:
            'https://s3-alpha-sig.figma.com/img/9dfb/7245/929efadae64ddbcebcc7571b22cbb0df?Expires=1688342400&Signature=hyrc07tB7D0308gKLTbS3DXlV1NjjyxXAdD8pBbWVa2I9jzVZIOhpTWWsEunZ9aCCKNcN9ZXhI7z7WcX2x-dBoK5kDUTPsxKjD45SQyy3BdNls2GyoToYLK72awwV9Ma4agMDbF6wDASNXQ36376UVFqOfndssDfPj3cN3NVutSVImZtI9EXIGm1Vc70Q9SQ~RuKIIqq6el396cHS54hITQPIEFcNRotbLZh4fZa7Airo8eu-R8BG6t72X1SdrboR93pD9zHIdktb6mIIRvblm49Jkc-AQz4nLr6F7a8AZz~hlTYIkEw8fypItMYp7KLptdcA2SDezOmb6LjK4oitg__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
        title: 'O Iluminado',
        pageCount: 190,
        pagesRead: 142,
      ),
      Book(
        id: 3,
        coverArt:
            'https://s3-alpha-sig.figma.com/img/0945/92c4/c342a44fe57ffa61249aa175384402fc?Expires=1688342400&Signature=b0kBoojZ0z6KP~ywYFDs98~rfiOyXg4qkH3AySCdKaqcCmx99MLlqYjPAi3Y3jhwgGlnIQPZnroS5NkUojvLlAC7HdDCHtbqaiqhM4WO60HVQ17gDnqDzKc5eCHfYJfTUFkPriMHpZ2nmIyKY843IHSG-i9qPhAfFHCHlzNoMxKqAbyoXUmmPSfdVtwceFCcyrg1uLcOhn9NE2c-LfYHttOrRrn5rFvejOxE7PapkW8Fg~Dk~ypRg0Oy3kNhH5lFl4mqbyGbjD19JoAwEYyAwWysj8-MC3QPxcyGwQLmRiiNJr40N0Z8v5w9G9nOdcD4tDh4NMzVikaNPV9f4Zt8Vw__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
        title: 'Clube da Luta',
        pageCount: 210,
        pagesRead: 87,
      ),
    ];

    return Column(
      children: [
        Expanded(
          child: books.isEmpty
              ? const GreetingContent()
              : BookCarrouselContent(books: books),
        ),
        const SizedBox(height: 84),
      ],
    );
  }
}
