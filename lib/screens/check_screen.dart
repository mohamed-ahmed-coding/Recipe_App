import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/constants/app_colors.dart';
import 'package:recipe_app/cubits/auth/auth_state.dart';
import 'package:recipe_app/cubits/favorites/favorites_cubit.dart';
import 'package:recipe_app/widgets/bottom_bar.dart';
import 'package:recipe_app/screens/splash_screen.dart';
import '../cubits/auth/auth_cubit.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  @override
  void initState() {
    super.initState();
    // Check login status as soon as the screen loads
    context.read<AuthCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.read<FavoritesCubit>().loadFavorites();
          // ✅ User is logged in → go to home
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomBar()));
        } if (state is AuthUnauthenticated) {
          context.read<FavoritesCubit>().clearFavorites();
          // ❌ Not logged in → go to login
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor), // Shows briefly while checking
        ),
      ),
    );
  }
}
