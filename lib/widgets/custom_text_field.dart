import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool autofocus;
  final bool readOnly;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final void Function()? onTap;

  const CustomTextField({
    super.key,
    this.prefixIcon,
    this.readOnly = false,
    this.controller,
    this.validator,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    required this.hintText,
    required this.keyboardType,
    this.autofocus = false,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 335.w,
      height: 55.h,
      decoration: BoxDecoration(
        color: AppColors.textFieldColor,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TextFormField(
        readOnly: readOnly,
        validator: validator,
        cursorColor: AppColors.primaryTextColor,
        autocorrect: false,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        autofocus: autofocus,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        onTap: onTap,
        decoration: InputDecoration(
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppColors.primaryTextColor)
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.placeholderColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 15.h,
          ),
        ),
      ),
    );
  }
}
