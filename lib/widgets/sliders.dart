import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/constants/app_colors.dart';

class Sliders extends StatelessWidget {
  final String title;
  final String image;
  const Sliders({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
              children: [
                Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.whiteColor)),
                      SizedBox(width: 44.w),
                      Image.asset(image, height: 100.h, width: 100.w)
                    ],
                  ),
                )
              ],
            ),
    );
  }
}