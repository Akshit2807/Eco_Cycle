import 'package:e_waste/core/utils/app_colors.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Camera button action
          Get.toNamed(
            RouteNavigation.cameraScreenRoute,
          );
        },
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        elevation: 5,
        child: const Icon(Icons.camera_alt, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      /// Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavigation(controller: controller),
      //Todo: make navigation bar with states
    );
  }
}
