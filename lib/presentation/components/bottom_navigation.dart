import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controller/Navigation/navigation_controller.dart';

class CustomBottomNavigation extends StatelessWidget {
  final NavigationController controller;

  const CustomBottomNavigation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedBottomNavigationBar(
        icons: const [
          Icons.home,
          Icons.groups,
          Icons.store,
          Icons.card_giftcard,
        ],
        activeIndex: controller.selectedIndex.value,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        backgroundColor: Colors.white54,
        activeColor: Colors.green,
        inactiveColor: Colors.grey,
        onTap: (index) => controller.changePage(index),
        leftCornerRadius: 0,
        rightCornerRadius: 0,
      ),
    );
  }
}
