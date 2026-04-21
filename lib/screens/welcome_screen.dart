import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/constants/app_colors.dart';
import 'package:recipe_app/screens/login_screen.dart';
import 'package:recipe_app/screens/signup_screen.dart';
import 'package:recipe_app/widgets/primary_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset(
                'assets/images/top_logo.png',
                width: double.infinity,
              ),
              Image.asset(
                'assets/images/app_logo.png',
                width: 225,
                height: 225,
                fit: BoxFit.contain,
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
            Text(
              "Discover The Best Food From Over 1,000\nRestaurants and fast delivery to your\ndoorstep",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondaryTextColor, fontSize: 14.sp),
            ),
          SizedBox(height: 25.h),
          PrimaryButton(
            text: 'Login',
            backgroundColor: AppColors.primaryColor,
            textColor: AppColors.whiteColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
          SizedBox(height: 30.h),
          PrimaryButton(
            text: 'Create An Account',
            backgroundColor: AppColors.whiteColor,
            textColor: AppColors.primaryColor,
            borderColor: AppColors.primaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignupScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}