import 'package:book_discovery_app/domain/repositories/book_respository.dart';
import 'package:book_discovery_app/presentation/books/bloc/books_bloc.dart';
import 'package:book_discovery_app/presentation/books/components/book_list_item.dart';
import 'package:book_discovery_app/presentation/navigation/bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookListScreen extends StatelessWidget{
  const BookListScreen({Key? key}):super(key:key);
  @override
  Widget build(BuildContext context) {
    BookRespository bookRespository=BookRespository();
    return BlocProvider(
      create: (context){
        final bloc=BooksBloc(bookRespository);
        bloc.add(GetBooksEvent());
        return bloc;
        },
      child: BlocConsumer<BooksBloc,BooksState>(
        listener: (context, state) => {},
        builder: (context,state){
          if(state is BookInitialState){
            return const Text("Initial State");
          }else if(state is BookError){
            return Text("There is an error: ${state.error}");
          }else if(state is BookLoadingState){
            return const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 5,
            );
          }else if(state is BookLoadedState){
            return Scaffold(
              appBar: AppBar(
                title: const Text('Book Discovery App'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: (){

                    },
                  )
                ],
              ),
              body: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemBuilder: (context, index) {
                  return BookListItem(book:state.books[index]);
                },
              ),
            );  
          }else{
            return const Text('');
          }
        }, 
        ),
    );
  }
}