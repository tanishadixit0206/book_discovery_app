import 'package:book_discovery_app/data/services/remote/api_service.dart';
import 'package:book_discovery_app/domain/models/book.dart';

class BookRespository {
  final _apiService =ApiService();

  Future<List<Book>> fetchBooks({int page=1}){
    return _apiService.fetchBooks(page:page);
  }
}