import 'package:dio/dio.dart';
import 'package:recipe_app/core/api/api_constants.dart';
import 'package:recipe_app/core/api/dio_helper.dart';
import 'package:recipe_app/models/recipe_mdel.dart';

class RecipeRepository {
  final DioHelper dio;

  RecipeRepository(this.dio);

  Future<List<Recipe>> getRecipes() async {
    try {
      final response = await dio.getData(
        ApiConstants.randomRecipes,
        {
          "apiKey": ApiConstants.apiKey,
          "number": 10,
        },
      );

      final data = response.data['recipes'] as List?;
      if (data == null) return [];
      return data.map((e) => Recipe.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_humanizeError(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    try {
      final response = await dio.getData(
        ApiConstants.searchRecipes,
        {
          "apiKey": ApiConstants.apiKey,
          "query": query,
          "number": 20,
          // include full recipe info so readyInMinutes and scores are available
          "addRecipeInformation": true,
        },
      );

      final data = response.data['results'] as List?;
      if (data == null) return [];
      return data.map((e) => Recipe.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_humanizeError(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Recipe> getRecipeDetails(int id) async {
    try {
      final response = await dio.getData(
        '/recipes/$id/information',
        {
          "apiKey": ApiConstants.apiKey,
          "includeNutrition": true,
        },
      );

      return Recipe.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_humanizeError(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  String _humanizeError(DioException e) {
    final status = e.response?.statusCode;
    if (status == 402) return 'API quota reached for today. Add a new Spoonacular key in ApiConstants.apiKey.';
    if (status == 401) return 'Invalid Spoonacular API key. Update ApiConstants.apiKey.';
    if (status == 429) return 'Spoonacular rate limit hit. Please wait and try again.';
    return e.message ?? 'Network error';
  }
}
