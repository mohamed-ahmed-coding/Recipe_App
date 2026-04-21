import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/models/recipe_mdel.dart';
import 'package:recipe_app/repo/favorites_repository.dart';

class FavoritesCubit extends Cubit<List<Recipe>> {
  FavoritesCubit({
    required FavoritesRepository repo,
    FirebaseAuth? auth,
  })  : _repo = repo,
        _auth = auth ?? FirebaseAuth.instance,
        super(const []);

  final FavoritesRepository _repo;
  final FirebaseAuth _auth;

  String? get _uid => _auth.currentUser?.uid;

  bool isFavorite(int recipeId) => state.any((recipe) => recipe.id == recipeId);

  Future<void> loadFavorites() async {
    final uid = _uid;
    if (uid == null) return;
    final favorites = await _repo.fetchFavorites(uid);
    emit(favorites);
  }

  Future<void> addFavorite(Recipe recipe) async {
    if (isFavorite(recipe.id)) return;
    final uid = _uid;
    if (uid == null) return;

    final previous = state;
    emit([...state, recipe]);
    try {
      await _repo.saveFavorite(uid, recipe);
    } catch (_) {
      emit(previous);
    }
  }

  Future<void> removeFavorite(int recipeId) async {
    final uid = _uid;
    if (uid == null) return;
    final previous = state;
    emit(state.where((recipe) => recipe.id != recipeId).toList());
    try {
      await _repo.removeFavorite(uid, recipeId);
    } catch (_) {
      emit(previous);
    }
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    if (isFavorite(recipe.id)) {
      await removeFavorite(recipe.id);
    } else {
      await addFavorite(recipe);
    }
  }

  void clearFavorites() => emit(const []);
}
