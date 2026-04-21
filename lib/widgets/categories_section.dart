import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/constants/app_colors.dart';
import 'package:recipe_app/core/api/recipe_service.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  List<String> _categories = [];
  bool _loadingCategories = true;
  String? _catError;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final result = await RecipeService().getRandomRecipes();
      final set = <String>{};
      for (final item in result) {
        final itemMap = item;
        final dishTypes = itemMap['dishTypes'] as List?;
        final cuisines = itemMap['cuisines'] as List?;
        final Iterable<dynamic> values = [
          ...?dishTypes,
          ...?cuisines,
        ];
        set.addAll(
          values.map((e) => e.toString()).where((e) => e.trim().isNotEmpty),
        );
      }
      setState(() {
        _categories = set.take(12).toList();
        _loadingCategories = false;
      });
    } catch (e) {
      setState(() {
        _catError = e.toString();
        _loadingCategories = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingCategories) {
      return const SizedBox(
        height: 110,
        child: Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
      );
    }
    if (_catError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Could not load categories. Please try again.',
          style: TextStyle(color: AppColors.secondaryTextColor, fontSize: 13.sp),
        ),
      );
    }
    if (_categories.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'No categories found right now.',
          style: TextStyle(color: AppColors.secondaryTextColor, fontSize: 13.sp),
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final label = _categories[index];
          return Container(
            width: 110.w,
            decoration: BoxDecoration(
              color: AppColors.textFieldColor,
              borderRadius: BorderRadius.circular(18.r),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.fastfood_rounded, color: AppColors.primaryColor),
                const SizedBox(height: 8),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
