import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controller/Navigation/navigation_controller.dart';
import '../../core/router/app_router.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import '../components/Drawer/main_screen_drawer.dart';
import '../components/bottom_navigation.dart';
import 'Home Screens/community_screen.dart';
import 'Home Screens/home_screen.dart';
import 'Home Screens/marketplace_screen.dart';
import 'Home Screens/reward_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final NavigationController controller = Get.put(NavigationController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? username;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    user = await UserRepository().fetchUserDetails();
    if (user != null) {
      setState(() {
        username = user?.username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        scaffoldKey: _scaffoldKey,
      ),
      CommunityScreen(
        scaffoldKey: _scaffoldKey,
      ),
      MarketplaceScreen(
        scaffoldKey: _scaffoldKey,
      ),
      RewardScreen(
        scaffoldKey: _scaffoldKey,
      )
    ];
    final List<FloatingActionButton> actionButtons = [
      FloatingActionButton(
        onPressed: () async {
          // Camera button action
          Get.toNamed(
            RouteNavigation.cameraScreenRoute,
          );
        },
        backgroundColor: AppColors.green,
        shape: const CircleBorder(),
        elevation: 5,
        child: const Icon(Icons.camera_alt, size: 30, color: Colors.white),
      ),
      FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteNavigation.createPostScreenRoute);
        },
        tooltip: 'Create a Post',
        backgroundColor: AppColors.green,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ), // Pencil icon.
      ),
      FloatingActionButton(
        onPressed: () {
          // Get.offAllNamed(RouteNavigation.createPostScreenRoute);
          // Navigator.pushNamed(context, '/createPost');
        },
        tooltip: 'Sell Product',
        backgroundColor: AppColors.green,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ), // Pencil icon.
      ),
      FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteNavigation.leaderboardScreenRoute);
        },
        tooltip: 'Leaderboard',
        backgroundColor: AppColors.green,
        shape: const CircleBorder(),
        child: Image.asset(
          AppIcons.leaderboard,
          height: 27,
          width: 27,
        ), // Pencil icon.
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.white,
      key: _scaffoldKey,

      /// Drawer
      drawer: myDrawer(context, user),

      /// Navigation Screens
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: PageView(
          controller: controller.pageController,
          onPageChanged: (index) => controller.selectedIndex.value = index,
          physics: const ClampingScrollPhysics(), // Smooth swiping
          children: pages,
        ),
      ),

      /// Floating Camera Button
      floatingActionButton:
          Obx(() => actionButtons[controller.selectedIndex.value]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      /// Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavigation(controller: controller),
      //Todo: make navigation bar with states
    );
  }
}
