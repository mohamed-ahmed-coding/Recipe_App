import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/repo/recipe_rebo.dart';
import 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final RecipeRepository repo;

  RecipeCubit(this.repo) : super(RecipeInitial());

  void getRecipes() async {
    emit(RecipeLoading());

    try {
      final recipes = await repo.getRecipes();
      emit(RecipeSuccess(recipes));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  void searchRecipes(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      emit(RecipeSuccess(const []));
      return;
    }

    emit(RecipeLoading());
    try {
      final recipes = await repo.searchRecipes(trimmed);
      emit(RecipeSuccess(recipes));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
}
