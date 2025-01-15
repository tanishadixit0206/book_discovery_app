part of 'books_bloc.dart';

abstract class BooksEvent {}

class GetBooksEvent extends BooksEvent{}

class SearchBooksEvent extends BooksEvent{
  final String query;
  SearchBooksEvent(this.query);
}

class LoadMoreBooksEvent extends BooksEvent {}
