import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/constants/app_colors.dart';
import 'package:recipe_app/widgets/sliders.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  double currentPage = 0;

  static const _slides = [
    Sliders(
      title: "Let's find the best\nrecipe for you",
      image: "assets/images/on_boarding_1.png",
    ),
    Sliders(
      title: "Get the best\nDiscount for you",
      image: "assets/images/on_boarding_2.png",
    ),
    Sliders(
      title: "The Best\n Delicious Food",
      image: "assets/images/on_boarding_3.png",
    ),
  ];

  int get _dotsCount => _slides.length;

  @override
  Widget build(BuildContext context) {
    final dotPosition = currentPage.clamp(0, (_dotsCount - 1).toDouble());
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 150.h,
            padEnds: false,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            enlargeFactor: 0.18,
            enableInfiniteScroll: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,
            onPageChanged: (index, reason) =>
                setState(() => currentPage = index.toDouble()),
          ),
          items: _slides,
        ),
        SizedBox(height: 16.h),
        DotsIndicator(
          dotsCount: _dotsCount,
          position: dotPosition as double,
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            color: Color(0xffE3E9ED),
            spacing: const EdgeInsets.symmetric(horizontal: 2.0),
            activeColor: AppColors.primaryColor,
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ],
    );
  }
}
