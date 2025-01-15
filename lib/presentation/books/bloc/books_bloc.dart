import 'dart:async';

import 'package:book_discovery_app/domain/models/book.dart';
import 'package:book_discovery_app/domain/repositories/book_respository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'books_event.dart';
part 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent,BooksState>{
  final BookRespository bookRespository;
  int currentPage=1;
  bool isFetching=false;
  Timer? _debounce;
  BooksBloc(this.bookRespository):super(BookInitialState()){
    on<GetBooksEvent>(_onGetBooks);
    on<SearchBooksEvent>(_onSearchBooks);
    on<LoadMoreBooksEvent>(_onLoadMoreBooks);
  }

  Future<void> _onGetBooks(event,emit) async {
    try{
      emit(BookLoadingState());
      final data=await bookRespository.fetchBooks(page:currentPage);
      emit(BookLoadedState(
        books:data,
        filteredBooks: data,
        hasReachedMax: data.isEmpty
        )); 
    }catch(error){
      emit(BookError(error));
    }

  }

Future<void> _onSearchBooks(event,emit) async {
      if (state is BookLoadedState) {
        final currentState = state as BookLoadedState;
        final query = event.query.toLowerCase();

        List<Book> filteredBooks;
        if (query.isEmpty) {
          filteredBooks = currentState.books;
        } else {
          filteredBooks = currentState.books
              .where((book) => book.title.toLowerCase().contains(query))
              .toList();
        }

        emit(BookLoadedState(
          books: currentState.books,
          filteredBooks: filteredBooks,
          hasReachedMax: currentState.hasReachedMax,
          query: query,
        ));
      }
}

  Future<void> _onLoadMoreBooks(event,emit) async {
    final currentState=state;
    if(currentState is BookLoadedState){
      if(currentState.hasReachedMax||isFetching) return;
    }
    try{
      isFetching=true;
      currentPage++;
      final books =await bookRespository.fetchBooks(page: currentPage);
      if(currentState is BookLoadedState){
        if(books.isEmpty){
          emit(BookLoadedState(
          books: currentState.books,
          hasReachedMax: true,
          ));
        }else{
          emit(BookLoadedState(
            books:[...currentState.books,...books],
            hasReachedMax: false,
          ));
        }
      }
    }catch(e){
      emit(BookError(e.toString()));
    }finally{
      isFetching=false;
    }
  }
}