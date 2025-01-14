import 'package:book_discovery_app/domain/models/book.dart';
import 'package:book_discovery_app/domain/repositories/book_respository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'books_event.dart';
part 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent,BooksState>{
  final BookRespository bookRespository;
  int currentPage=1;
  bool isFetching=false;
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
        hasReachedMax: data.isEmpty
        )); 
    }catch(error){
      emit(BookError(error));
    }

  }

  void _onSearchBooks(event,emit){
    
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