import 'package:equatable/equatable.dart';
import 'package:recipe_app/models/recipe_mdel.dart';

abstract class RecipeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeSuccess extends RecipeState {
  final List<Recipe> recipes;

  RecipeSuccess(this.recipes);

  @override
  List<Object?> get props => [recipes];
}

class RecipeError extends RecipeState {
  final String message;

  RecipeError(this.message);

  @override
  List<Object?> get props => [message];
}