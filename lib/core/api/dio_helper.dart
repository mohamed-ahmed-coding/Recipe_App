import 'package:dio/dio.dart';

class DioHelper {
  final Dio dio;

  DioHelper()
      : dio = Dio(BaseOptions(
          baseUrl: "https://api.spoonacular.com",
          receiveDataWhenStatusError: true,
        ));

  Future<Response> getData(String path, Map<String, dynamic> query) async {
    return await dio.get(path, queryParameters: query);
  }
}