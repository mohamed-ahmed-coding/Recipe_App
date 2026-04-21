// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/constants/app_colors.dart';
import 'package:recipe_app/cubits/favorites/favorites_cubit.dart';
import 'package:recipe_app/models/recipe_mdel.dart';
import 'package:recipe_app/screens/details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        foregroundColor: AppColors.primaryTextColor,
        title: Text(
          'Favorites',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: BlocBuilder<FavoritesCubit, List<Recipe>>(
            builder: (context, favorites) {
              if (favorites.isEmpty) {
                return Center(
                  child: Text(
                    'You have no\nfavorite recipes yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryTextColor,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: favorites.length,
                separatorBuilder: (_, _) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final recipe = favorites[index];
                  return _FavoriteTile(recipe: recipe);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  final Recipe recipe;

  const _FavoriteTile({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailsScreen(recipe: recipe)),
        );
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Dismissible(
        key: Key(recipe.id.toString()),
        background: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 20.w),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(
            Icons.delete,
            color: AppColors.whiteColor,
            size: 26.sp,
          ),
        ),
        direction: DismissDirection.horizontal,
        onDismissed: (_) {
          context.read<FavoritesCubit>().removeFavorite(recipe.id);
        },
        child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
              ),
              child: SizedBox(
                width: 110.w,
                height: 110.w,
                child: Image.network(
                  recipe.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: AppColors.textFieldColor,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppColors.placeholderColor,
                      size: 26.sp,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16.sp,
                          color: AppColors.secondaryTextColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${recipe.readyInMinutes} min',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Icon(
                          Icons.star,
                          size: 16.sp,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          recipe.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
