import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dashboard/community_screen.dart';
import '../dashboard/home_screen.dart';
import '../dashboard/marketplace_screen.dart';
import '../dashboard/reward_screen.dart';

class NavigationController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final PageController pageController = PageController(initialPage: 0);

  void changePage(int index) {
    selectedIndex.value = index;
    pageController.jumpToPage(index);
  }
}

class NavigationScreen extends StatelessWidget {
  final NavigationController controller = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(),
      CommunityScreen(),
      MarketplaceScreen(),
      RewardScreen()
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      /// Navigation Screens
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (index) => controller.selectedIndex.value = index,
        physics: ClampingScrollPhysics(), // Smooth swiping
        children: pages,
      ),

      /// Floating Camera Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Camera button action
          print("Camera Button Pressed");
        },
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        elevation: 5,
        child: const Icon(Icons.camera_alt, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      /// Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavigation(controller: controller),
    );
  }
}

class CustomBottomNavigation extends StatelessWidget {
  final NavigationController controller;

  const CustomBottomNavigation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedBottomNavigationBar(
        icons: [
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
        leftCornerRadius: 30,
        rightCornerRadius: 30,
      ),
    );
  }
}
