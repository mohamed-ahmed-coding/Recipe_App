class Recipe {
  final int id;
  final String title;
  final String image;
  final int readyInMinutes;
  final double rating;
  final List<String> ingredients;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.readyInMinutes,
    required this.rating,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final rawIngredients = json['extendedIngredients'] as List?;
    final ingredients = rawIngredients == null
        ? <String>[]
        : rawIngredients
            .map((e) => (e as Map<String, dynamic>?)?['original']?.toString() ?? '')
            .where((e) => e.trim().isNotEmpty)
            .toList();

    return Recipe(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      readyInMinutes: (json['readyInMinutes'] ?? 0) is int
          ? json['readyInMinutes'] as int
          : int.tryParse(json['readyInMinutes']?.toString() ?? '0') ?? 0,
      rating: ((json['spoonacularScore'] ?? json['healthScore'] ?? 0) / 20 as num)
          .toDouble(),
      ingredients: ingredients,
    );
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: _parseInt(map['id']),
      title: map['title']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      readyInMinutes: _parseInt(map['readyInMinutes']),
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      ingredients: (map['ingredients'] as List?)
              ?.map((e) => e.toString())
              .where((e) => e.trim().isNotEmpty)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'readyInMinutes': readyInMinutes,
      'rating': rating,
      'ingredients': ingredients,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
