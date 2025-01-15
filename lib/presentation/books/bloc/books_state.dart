part of 'books_bloc.dart';

abstract class BooksState {}

class BookInitialState extends BooksState{}

class BookLoadingState extends BooksState{}

class BookError extends BooksState{
  final error;
  BookError(this.error);
}

class BookLoadedState extends BooksState{
  final List<Book> books;
  final List<Book> filteredBooks;
  final String query;
  final bool hasReachedMax;

  BookLoadedState({
    required this.books, 
    this.hasReachedMax=false,
    List<Book>? filteredBooks,
    this.query=''
    }):filteredBooks=filteredBooks??books;

   BookLoadedState copyWith({
    List<Book>? books,
    List<Book>? filteredBooks,
    bool? hasReachedMax,
    String? query,
  }) {
    return BookLoadedState(
      books: books ?? this.books,
      filteredBooks: filteredBooks,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      query: query ?? this.query,
    );
  }
}
