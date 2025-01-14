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
  final bool hasReachedMax;
  BookLoadedState({required this.books, this.hasReachedMax=false});
  
}
