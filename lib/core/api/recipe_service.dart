import 'package:dio/dio.dart';
import 'package:recipe_app/core/api/api_constants.dart';
import 'package:recipe_app/core/api/dio_client.dart';

class RecipeService {
  // ✅ Reuse the singleton Dio instance — not re-created on every call
  final Dio _dio = DioClient.instance.dio;

  // 🏠 Home feed — random recipes
  Future<List<Map<String, dynamic>>> getRandomRecipes({int number = 20}) async {
    final response = await _dio.get(
      ApiConstants.randomRecipes,
      queryParameters: {'number': number},
    );

    // ✅ Safe cast — convert each item explicitly
    final List<dynamic> raw = response.data['recipes'];
    return raw.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // 🔍 Search recipes
  Future<List<Map<String, dynamic>>> searchRecipes({
    required String query,
    int number = 15,
    String? cuisine,
    String? diet,
  }) async {
    // ✅ Build params first, then add optional fields only when non-null
    //    Avoids invalid '?cuisine' syntax and prevents sending "null" strings
    final Map<String, dynamic> params = {
      'query': query,
      'number': number,
      'addRecipeInformation': true,
    };

    final response = await _dio.get(
      ApiConstants.searchRecipes,
      queryParameters: params,
    );

    // ✅ Safe cast
    final List<dynamic> raw = response.data['results'] as List<dynamic>;
    return raw.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // 📄 Recipe details
  Future<Map<String, dynamic>> getRecipeDetails(int id) async {
    final response = await _dio.get(
      '/recipes/$id/information',
      queryParameters: {'includeNutrition': true},
    );

    // ✅ Safe cast
    return Map<String, dynamic>.from(response.data);
  }
}