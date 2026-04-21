// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/constants/app_colors.dart';
import 'package:recipe_app/cubits/favorites/favorites_cubit.dart';
import 'package:recipe_app/models/recipe_mdel.dart';
import 'package:recipe_app/widgets/primary_button.dart';

class DetailsScreen extends StatefulWidget {
  final Recipe recipe;
  const DetailsScreen({super.key, required this.recipe});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoritesCubit, bool>(
      (cubit) => cubit.isFavorite(widget.recipe.id),
    );

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.blackColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    widget.recipe.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.textFieldColor,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppColors.placeholderColor,
                        size: 36.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                widget.recipe.title,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 18.sp,
                    color: AppColors.secondaryTextColor,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '${widget.recipe.readyInMinutes} min',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.secondaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Icon(Icons.star, size: 18.sp, color: AppColors.primaryColor),
                  SizedBox(width: 6.w),
                  Text(
                    widget.recipe.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.primaryTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 10.h),
              if (widget.recipe.ingredients.isEmpty)
                Text(
                  'Ingredients not available.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.secondaryTextColor,
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.recipe.ingredients.length,
                  separatorBuilder: (_, _) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final item = widget.recipe.ingredients[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 8.r,
                          height: 8.r,
                          margin: EdgeInsets.only(top: 6.h),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.primaryTextColor,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  PrimaryButton(
                    onPressed: () {
                      context.read<FavoritesCubit>().toggleFavorite(
                        widget.recipe,
                      );
                    },
                    text: isFavorite
                        ? "Remove from Favorites"
                        : "Add to Favorites",
                    textColor: AppColors.whiteColor,
                    backgroundColor: AppColors.primaryColor,
                    width: 275.w,
                  ),
                  SizedBox(width: 5.w),
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTextColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                      ),
                      color: isFavorite
                          ? AppColors.primaryColor
                          : AppColors.placeholderColor,
                      onPressed: () {
                        context.read<FavoritesCubit>().toggleFavorite(
                          widget.recipe,
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
