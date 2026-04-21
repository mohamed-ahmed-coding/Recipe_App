import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/models/recipe_mdel.dart';

class FavoritesRepository {
  FavoritesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String uid) {
    return _firestore.collection('users').doc(uid).collection('favorites');
  }

  Future<List<Recipe>> fetchFavorites(String uid) async {
    final snapshot = await _collection(uid).get();
    return snapshot.docs
        .map((doc) => Recipe.fromMap(doc.data()))
        .toList();
  }

  Future<void> saveFavorite(String uid, Recipe recipe) async {
    await _collection(uid)
        .doc(recipe.id.toString())
        .set(recipe.toMap());
  }

  Future<void> removeFavorite(String uid, int recipeId) async {
    await _collection(uid).doc(recipeId.toString()).delete();
  }
}
