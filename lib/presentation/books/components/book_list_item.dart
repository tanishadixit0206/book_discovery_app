import 'package:book_discovery_app/domain/models/book.dart';
import 'package:book_discovery_app/domain/repositories/book_respository.dart';
import 'package:book_discovery_app/presentation/books/bloc/books_bloc.dart';
import 'package:book_discovery_app/presentation/books/screens/book_details_screen.dart';
import 'package:book_discovery_app/presentation/navigation/bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookListItem extends StatelessWidget{
  final Book book;
  const BookListItem({Key?key,required this.book}):super(key:key);

  @override
  Widget build(BuildContext context) {
    BookRespository bookRespository =BookRespository();
    return BlocProvider(
      create: (context) => BooksBloc(bookRespository),
      child: BlocConsumer<BooksBloc,BooksState>(
        listener: (context, state) => {},
        builder: (context, state) {
          return GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailsScreen(book: book),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        width: 150,  
                        height: 200, 
                        child: Image.network(
                          'https://www.gutenberg.org/cache/epub/${book.bookId}/pg${book.bookId}.cover.medium.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.book, size: 50),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.authors[0].name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
          },
      ),
    );
  }
}