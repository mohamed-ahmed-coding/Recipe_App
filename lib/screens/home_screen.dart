// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/constants/app_colors.dart';
import 'package:recipe_app/screens/details_screen.dart';
import 'package:recipe_app/screens/profile_screen.dart';
import 'package:recipe_app/screens/search_screen.dart';
import 'package:recipe_app/repo/recipe_rebo.dart';
import 'package:recipe_app/repo/user_repository.dart';
import 'package:recipe_app/widgets/carsoul.dart';
import 'package:recipe_app/widgets/custom_text_field.dart';
import 'package:recipe_app/cubits/recipe/recipe_cubit.dart';
import 'package:recipe_app/cubits/recipe/recipe_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final UserRepository _userRepository = UserRepository();
  String? _firestoreName;

  @override
  void initState() {
    super.initState();
    context.read<RecipeCubit>().getRecipes();
    _loadUserName();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final user = await _userRepository.getUser(uid);
    if (!mounted) return;
    setState(() {
      _firestoreName = (user?.name.isNotEmpty ?? false) ? user!.name : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final welcomeName = _firestoreName ??
        (user?.displayName?.isNotEmpty == true ? user!.displayName! : 'Friend');
    final avatarUrl = user?.photoURL ?? '';

    final header = [
      SizedBox(height: 25.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Welcome \n$welcomeName",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) =>
                        RecipeCubit(context.read<RecipeRepository>()),
                    child: ProfileScreen(),
                  ),
                ),
              ).then((_) => _loadUserName());
            },
            child: CircleAvatar(
              radius: 35.r,
              backgroundImage: avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : null,
              backgroundColor: AppColors.whiteColor,
              child: avatarUrl.isEmpty
                  ? Container(
                    width: 90.w,
                    height: 90.h,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                        Icons.person,
                        color: AppColors.primaryTextColor,
                        size: 35.r,
                      ),
                  )
                  : null,
            ),
          ),
        ],
      ),
      SizedBox(height: 20.h),
      CustomTextField(
        controller: _searchController,
        hintText: "Search Food",
        keyboardType: TextInputType.text,
        prefixIcon: Icons.search,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) =>
                    RecipeCubit(context.read<RecipeRepository>()),
                child: SearchScreen(
                  initialQuery: _searchController.text,
                ),
              ),
            ),
          );
        },
      ),
      SizedBox(height: 30.h),
      Carousel(),
      SizedBox(height: 24.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Our recipes",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
        ],
      ),
      SizedBox(height: 12.h),
    ];

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: BlocBuilder<RecipeCubit, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoading || state is RecipeInitial) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: header,
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is RecipeError) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: header,
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message.isNotEmpty
                                ? state.message
                                : 'Failed to load recipes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.secondaryTextColor,
                              fontSize: 14.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                context.read<RecipeCubit>().getRecipes(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                  ),
                ],
              );
            } else if (state is RecipeSuccess) {
              final recipes = state.recipes;
              return RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () async => context.read<RecipeCubit>().getRecipes(),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: header,
                      ),
                    ),
                    if (recipes.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: const Center(
                          child: Text(
                            'No recipes available',
                            style: TextStyle(
                              color: AppColors.secondaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.only(bottom: 12.h, top: 4.h),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (
                              context,
                              index,
                            ) {
                              final recipe = recipes[index];
                              return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                      recipe: recipe,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.blackColor.withOpacity(
                                        0.06,
                                      ),
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
                                              (
                                                context,
                                                error,
                                                stackTrace,
                                              ) => Container(
                                                color: AppColors.textFieldColor,
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: AppColors
                                                      .placeholderColor,
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    size: 16.sp,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    recipe.rating
                                                        .toStringAsFixed(1),
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                            childCount: recipes.length,
                          ),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 0.75,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
