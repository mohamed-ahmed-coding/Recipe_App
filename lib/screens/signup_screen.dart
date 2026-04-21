// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/constants/app_colors.dart';
import 'package:recipe_app/cubits/auth/auth_cubit.dart';
import 'package:recipe_app/cubits/auth/auth_state.dart';
import 'package:recipe_app/cubits/favorites/favorites_cubit.dart';
import 'package:recipe_app/screens/home_screen.dart';
import 'package:recipe_app/screens/login_screen.dart';
import 'package:recipe_app/widgets/custom_text_field.dart';
import 'package:recipe_app/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {

  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    txtemail = TextEditingController();
    txtpassword = TextEditingController();
    confirmpassword = TextEditingController();
    name = TextEditingController();
    address = TextEditingController();
  }

  @override
  void dispose() {
    txtemail.dispose();
    txtpassword.dispose();
    confirmpassword.dispose();
    name.dispose();
    super.dispose();
  }

  void _submit() {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().signUp(
            name: name.text,
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
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
                              child: Text('Sign Up', style: TextStyle(color: AppColors.primaryTextColor, fontSize: 30.sp, fontWeight: FontWeight.w800),
                              ),
                            ),
                            SizedBox(height: 10.w),
                            Text('Add Your Details Here', style: TextStyle(color: AppColors.secondaryTextColor, fontSize: 16.sp)),
                            SizedBox(height: 30.h),
                            CustomTextField(
                              hintText: 'Name',
                              keyboardType: TextInputType.text,
                              controller: name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 25.h),
                            CustomTextField(
                              hintText: 'Your Email',
                              keyboardType: TextInputType.emailAddress,
                              controller: txtemail,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                if (!value.endsWith('.com')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 25.h),
                            CustomTextField(
                              hintText: 'Your Address',
                              controller: address,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your address';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 25.h),
                            CustomTextField(
                              hintText: 'Password',
                              controller: txtpassword,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 25.h),
                            CustomTextField(
                              hintText: 'Confirm Password',
                              obscureText: true,
                              controller: confirmpassword,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value != txtpassword.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30.h),
                            PrimaryButton(onPressed: (){
                              isLoading ? null : _submit();
                            }
                            ,text: 'Sign Up', textColor: AppColors.whiteColor, backgroundColor: AppColors.primaryColor),
                            SizedBox(height: 155.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Already have an account?', style: TextStyle(color: AppColors.secondaryTextColor, fontSize: 16.sp, fontWeight: FontWeight.w500),),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                                  },
                                  child: Text(' Sign In', style: TextStyle(color: AppColors.primaryColor, fontSize: 16.sp, fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            )
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
