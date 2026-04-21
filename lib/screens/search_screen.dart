
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/constants/app_colors.dart';
import 'package:recipe_app/cubits/recipe/recipe_cubit.dart';
import 'package:recipe_app/cubits/recipe/recipe_state.dart';
import 'package:recipe_app/screens/details_screen.dart';
import 'package:recipe_app/widgets/custom_text_field.dart';

class SearchScreen extends StatefulWidget {
  final String initialQuery;

  const SearchScreen({
    super.key,
    this.initialQuery = '',
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    // Trigger an initial search if the user had already typed something.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialQuery.trim().isNotEmpty) {
        _triggerSearch(widget.initialQuery);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerSearch([String? value]) {
    final query = (value ?? _controller.text).trim();
    if (query.isEmpty) return;
    context.read<RecipeCubit>().searchRecipes(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: AppColors.whiteColor,
        elevation: 0,
        foregroundColor: AppColors.whiteColor,
        title: Text('Search', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTextColor, fontSize: 24.sp)),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryColor,
          backgroundColor: AppColors.whiteColor,
          onRefresh: () async => _triggerSearch(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: _controller,
                  hintText: 'Search recipes',
                  keyboardType: TextInputType.text,
                  prefixIcon: Icons.search,
                  autofocus: true,
                  onFieldSubmitted: _triggerSearch,
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: BlocBuilder<RecipeCubit, RecipeState>(
                    builder: (context, state) {
                      if (state is RecipeInitial) {
                        return Center(
                          child: Text(
                            'Type a recipe name to search',
                            style: TextStyle(
                              color: AppColors.secondaryTextColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        );
                      }
          
                      if (state is RecipeLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      }

                      if (state is RecipeError) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Text(
                                state.message.isNotEmpty
                                    ? state.message
                                    : 'Something went wrong',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.secondaryTextColor,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextButton(
                              onPressed: _triggerSearch,
                              child: const Text('Retry'),
                            ),
                          ],
                        );
                      }
          
                      if (state is RecipeSuccess) {
                        final recipes = state.recipes;
                        if (recipes.isEmpty) {
                          return Center(
                            child: Text(
                              'No recipes found for "${_controller.text}"',
                              style: TextStyle(
                                color: AppColors.secondaryTextColor,
                                fontSize: 14.sp,
                              ),
                            ),
                          );
                        }
          
                        return GridView.builder(
                          padding: EdgeInsets.only(bottom: 12.h),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            final recipe = recipes[index];
                            return InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(recipe: recipe),
                                ),
                              ),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16.r),
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 1.1,
                                        child: Image.network(
                                          recipe.image,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            color: AppColors.textFieldColor,
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.image_not_supported,
                                              color: AppColors.placeholderColor,
                                              size: 28.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 8.h,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            recipe.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryTextColor,
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    size: 16.sp,
                                                    color: AppColors
                                                        .secondaryTextColor,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    '${recipe.readyInMinutes} min',
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: AppColors
                                                          .secondaryTextColor,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    size: 16.sp,
                                                    color: AppColors.primaryColor,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    recipe.rating
                                                        .toStringAsFixed(1),
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColors
                                                          .primaryTextColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
          
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}