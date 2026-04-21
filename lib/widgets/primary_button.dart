import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double? width;
  final Color? borderColor;
  final Image? image;
  const PrimaryButton({super.key, this.image ,required this.onPressed, required this.text, required this.textColor, required this.backgroundColor, this.borderColor, this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width ?? 335.w,
        height: 56.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: borderColor ?? Colors.transparent),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ?image,
              SizedBox(width: 8.w),
              Text(
                  text,
                  style: TextStyle(color: textColor, fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ),
      ),
    );
  }
}