import 'package:book_discovery_app/domain/repositories/book_respository.dart';
import 'package:book_discovery_app/presentation/books/bloc/books_bloc.dart';
import 'package:book_discovery_app/presentation/books/components/book_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookListScreen extends StatelessWidget {
  const BookListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = BooksBloc(BookRespository());
        bloc.add(GetBooksEvent());
        return bloc;
      },
      child: BlocBuilder<BooksBloc, BooksState>(
        builder: (context, state) {
          if (state is BookInitialState) {
            return const Center(child: Text("Initial State"));
          } else if (state is BookError) {
            return Center(child: Text("Error: ${state.error}"));
          } else if (state is BookLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 5,
              ),
            );
          } else if (state is BookLoadedState) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Book Discovery App'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      
                    },
                  )
                ],
              ),
              body: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!state.hasReachedMax && 
                      scrollInfo.metrics.pixels >= 
                      scrollInfo.metrics.maxScrollExtent * 0.9) {
                    context.read<BooksBloc>().add(LoadMoreBooksEvent());
                  }
                  return true;
                },
                child: GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: state.books.length + (state.hasReachedMax ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index >= state.books.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return BookListItem(book: state.books[index]);
                  },
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}