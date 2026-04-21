// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:recipe_app/constants/app_colors.dart';
import 'package:recipe_app/screens/welcome_screen.dart';

class _SlideData {
  final String title;
  final String subtitle;
  final Image image;

  const _SlideData({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

const _slides = [
  _SlideData(
    title: 'Find Food You Love',
    subtitle: 'Discover a better way to manage your daily tasks with ease and efficiency.',
    image: Image(
      image: AssetImage('assets/images/on_boarding_1.png'
      ),
    )
  ),
  _SlideData(
    title: 'Fast Delivery',
    subtitle: 'Fast Food Delivery to Your Home.',
    image: Image(
      image: AssetImage('assets/images/on_boarding_2.png'
      ),
    )
  ),
  _SlideData(
    title: "Live Tracking",
    subtitle: 'Real Time Location Tracking.',
    image: Image(
      image: AssetImage('assets/images/on_boarding_3.png'
      ),
    )
  ),
];

// ── Main Screen ───────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _current = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_current < _slides.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WelcomeScreen())),
                child: Text(
                  _current == _slides.length - 1 ? '' : 'Skip',
                  style: const TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            // ── Page view
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (_, i) => _SlideItem(data: _slides[i]),
              ),
            ),
            // ── Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _current == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.placeholderColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ── Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _current == _slides.length - 1 ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

// ── Slide Item ────────────────────────────────────────────────

class _SlideItem extends StatelessWidget {
  final _SlideData data;
  const _SlideItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          data.image,
          const SizedBox(height: 25),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}