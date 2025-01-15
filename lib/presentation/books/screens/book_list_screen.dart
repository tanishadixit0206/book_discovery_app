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
            return const _LoadingPlaceholder(message: "Preparing your library...");
          } else if (state is BookError) {
            return _ErrorView(error: state.error);
          } else if (state is BookLoadingState) {
            return const _LoadingPlaceholder(message: "Loading books...");
          }

          final loadedState = state as BookLoadedState;

          return Scaffold(
            backgroundColor: const Color(0xFFF5F0FF),
            body: Column(
              children: [
                Container(
                  color: const Color(0xFF6200EE),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        // App Bar
                        Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.bottomLeft,
                          child: const Text(
                            'Discover Books',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SearchBar(
                            hintText: 'Search books by title...',
                            onChanged: (value) {
                              context.read<BooksBloc>().add(SearchBooksEvent(value));
                            },
                            padding: const MaterialStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                            leading: const Icon(Icons.search, color: Color(0xFF6200EE)),
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            elevation: MaterialStateProperty.all(3),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Grid View
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (!loadedState.hasReachedMax &&
                          loadedState.query.isEmpty &&
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
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 24.0,
                      ),
                      itemCount: loadedState.filteredBooks.length +
                          (!loadedState.hasReachedMax && loadedState.query.isEmpty ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= loadedState.filteredBooks.length) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  const Color(0xFF6200EE),
                                ),
                              ),
                            ),
                          );
                        }
                        return BookListItem(book: loadedState.filteredBooks[index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  final String message;

  const _LoadingPlaceholder({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF6200EE),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16.0,
                color: Color(0xFF6200EE),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;

  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48.0,
                color: Color(0xFF6200EE),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Oops! Something went wrong',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF6200EE),
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                error,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6200EE).withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6200EE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  context.read<BooksBloc>().add(GetBooksEvent());
                },
                child: const Text(
                  'Try Again',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}