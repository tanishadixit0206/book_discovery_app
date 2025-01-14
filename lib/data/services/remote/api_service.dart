import 'package:book_discovery_app/data/constants/env_config.dart';
import 'package:book_discovery_app/domain/models/book.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio =Dio();
  final String baseUrl=EnvConfig.BASE_URL;

  Future<List<Book>> fetchBooks() async{
    try{
      final Response response = await _dio.get(baseUrl);
      print("Response: ${response.data['results']}");
      if(response.statusCode==200){
        return (response.data['results'] as List).map((json)=>Book.fromJson(json)).toList();
      }else{
        throw DioException(
          requestOptions: RequestOptions(path: baseUrl),
          error: 'Failed to fetch books. Status code: ${response.statusCode}'
          );
      }
    }on DioException catch(e){
      throw DioException(
        requestOptions: RequestOptions(path: baseUrl),
        error: 'Network error occurred:${e.message}'
        );
    }
  }
}