// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/constants/app_colors.dart';
import 'package:recipe_app/cubits/auth/auth_cubit.dart';
import 'package:recipe_app/cubits/auth/auth_state.dart';
import 'package:recipe_app/cubits/favorites/favorites_cubit.dart';
import 'package:recipe_app/screens/signup_screen.dart';
import 'package:recipe_app/widgets/bottom_bar.dart';
import 'package:recipe_app/widgets/custom_text_field.dart';
import 'package:recipe_app/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    txtemail = TextEditingController();
    txtpassword = TextEditingController();
  }

  @override
  void dispose() {
    txtemail.dispose();
    txtpassword.dispose();
    super.dispose();
  }


  void _submit() {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            email: txtemail.text,
            password: txtpassword.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.read<FavoritesCubit>().loadFavorites();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar()));
          }
        else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red,),
          );
        }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Form(
            key: formKey,
            child: SingleChildScrollView(
          child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 55.h),
                          Center(
                            child: Text('Login', style: TextStyle(color: AppColors.primaryTextColor, fontSize: 30.sp, fontWeight: FontWeight.w800),
                            ),
                          ),
                          SizedBox(height: 10.w),
                          Text('Add Your Details Here', style: TextStyle(color: AppColors.secondaryTextColor, fontSize: 16.sp)),
                          SizedBox(height: 30.h),
                          CustomTextField(
                            hintText: 'Your Email',
                            keyboardType: TextInputType.emailAddress,
                            controller: txtemail,
                            validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                          SizedBox(height: 25.h),
                          CustomTextField(
                            hintText: 'Your Password',
                            obscureText: true,
                            controller: txtpassword,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                            }
                          ),
                          SizedBox(height: 30.h),
                          PrimaryButton(onPressed: (){
                            isLoading ? CircularProgressIndicator(color: AppColors.primaryColor) : _submit();
                          },text: 'Login', textColor: AppColors.whiteColor, backgroundColor: AppColors.primaryColor),
                          SizedBox(height: 25.h),
                          Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          GestureDetector(
                            onTap: () {
                              
                            },
                          child: Text('Forgot Your Password?', style: TextStyle(color: AppColors.secondaryTextColor, fontSize: 14.sp))
                        ),
                    ],
                  ),
                  SizedBox(height: 50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 110.w,
                        height: 1.w,
                        color: AppColors.secondaryTextColor,
                      ),
                      Text('Or Login With', style: TextStyle(color: AppColors.secondaryTextColor, fontSize: 14.sp)),
                      Container(
                        width: 110.w,
                        height: 1.w,
                        color: AppColors.secondaryTextColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  PrimaryButton(onPressed: () {
                    isLoading ? CircularProgressIndicator(color: AppColors.primaryColor) :
                    context.read<AuthCubit>().signInWithGoogle();
                  }, 
                  image: Image.asset('assets/images/google_logo.png', width: 25.w, height: 25.h),
                  text: "Login With Google", 
                  textColor: AppColors.primaryColor, 
                  backgroundColor: AppColors.whiteColor, 
                  borderColor: AppColors.primaryColor,
                  ),
                SizedBox(height: 180.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account? ', style: TextStyle(color: AppColors.secondaryTextColor, fontSize: 14.sp)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                      },
                      child: Text('Sign Up', style: TextStyle(color: AppColors.primaryColor, fontSize: 14.sp)),
                    ),
                  ],
                ),
                ],
              ),
            ),
          ),
          );
        },
      ),
    );
  }
}
