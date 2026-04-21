// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:recipe_app/constants/app_colors.dart';
import 'package:recipe_app/screens/favorites_screen.dart';
import 'package:recipe_app/screens/home_screen.dart';
import 'package:recipe_app/screens/profile_screen.dart';
import 'package:recipe_app/screens/search_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BoottomBarState();
}

class _BoottomBarState extends State<BottomBar> {
  static const _items = [
    _NavItem(label: 'Home', asset: Icons.home_rounded),
    _NavItem(label: 'Search', asset: Icons.search),
    _NavItem(label: 'Favorites', asset:  Icons.favorite),
    _NavItem(label: 'Profile', asset: Icons.person),
  ];

  static const _pages = [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.secondaryTextColor,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
          items: List.generate(_items.length, (i) {
            final item = _items[i];
            final active = _currentIndex == i;
            return BottomNavigationBarItem(
              label: item.label,
              icon: _NavIcon(asset: item.asset, active: active),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData asset;

  const _NavItem({required this.label, required this.asset});
}

class _NavIcon extends StatelessWidget {
  final IconData asset;
  final bool active;

  const _NavIcon({required this.asset, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: active
          ? BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: Icon(
        asset,
        size: 25,
        color: active ? AppColors.primaryColor : AppColors.secondaryTextColor,
      )
    );
  }
}