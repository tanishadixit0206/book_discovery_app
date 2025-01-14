import 'package:book_discovery_app/domain/models/book.dart';
import 'package:book_discovery_app/domain/repositories/book_respository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'books_event.dart';
part 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent,BooksState>{
  final BookRespository bookRespository;
  BooksBloc(this.bookRespository):super(BookInitialState()){
    on<GetBooksEvent>(_onGetBooks);
    on<SearchBooksEvent>(_onSearchBooks);
  }

  Future<void> _onGetBooks(event,emit) async {
    try{
      emit(BookLoadingState());
      final data=await bookRespository.fetchBooks();
      print(data);
      emit(BookLoadedState(data)); 
    }catch(error){
      emit(BookError(error));
    }

  }

  void _onSearchBooks(event,emit){
    
  }
}