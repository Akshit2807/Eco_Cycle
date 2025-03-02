import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:e_waste/core/services/camera_service.dart';
import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_icons.dart';
import 'package:e_waste/presentation/dashboard/Home%20Screens/marketplace_screen.dart';
import 'package:e_waste/viewmodels/auth_viewmodel.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/router/app_router.dart';
import '../dashboard/Home Screens/community_screen.dart';
import '../dashboard/Home Screens/home_screen.dart';
import '../dashboard/Home Screens/reward_screen.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  NavigationScreen({super.key});

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
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24))),
        child: Stack(
          children: [
            Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 0.47],
                  colors: [AppColors.green, Colors.white],
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.2,
                  // Dynamic size
                  child: const Image(
                    image: AssetImage("assets/prf.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Center(
                  child: CustomText(
                    textName: "Sarthak Patil",
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(24),
                            topLeft: Radius.circular(24))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildDrawerTile(AppIcons.home, "Home", true),
                          buildDrawerTile(AppIcons.edit, "Edit Profile", false),
                          buildDrawerTile(
                              AppIcons.bookmark2, "Bookmarks", false),
                          buildDrawerTile(AppIcons.faq, "FAQ", false),
                          buildDrawerTile(
                              AppIcons.bill, "Billing & Address", false),
                          buildDrawerTile(AppIcons.help, "Help", false),
                          buildDrawerTile(AppIcons.sf, "S&F", false),
                          buildDrawerTile(AppIcons.setting, "Settings", false),
                          buildDrawerTile(
                            AppIcons.logout,
                            "Logout",
                            false,
                            onTileTap: () {
                              AuthViewModel().signOut(context);
                            },
                          ),
                          CustomText(
                            textName: " V 1.253.450",
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            textColor: AppColors.green,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),

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
          String? base64 = await CameraService().imgToBase64();
          if (base64 != null) {
            Get.toNamed(RouteNavigation.cameraScreenRoute,
                arguments: {"base64Image": base64});
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Something Went Wrong"),
                  backgroundColor: Colors.red),
            );
          }
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

  Widget buildDrawerTile(String icon, String title, bool selected,
      {VoidCallback? onTileTap}) {
    return GestureDetector(
      onTap: () {
        if (onTileTap != null) {
          onTileTap();
          selected = true;
        } else {
          print("No action");
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ImageIcon(
            AssetImage(icon),
            size: 24,
            color: selected ? AppColors.green : AppColors.dark,
          ),
          const SizedBox(
            width: 16,
          ),
          CustomText(
            textName: title,
            fontWeight: FontWeight.w500,
            fontSize: 20,
            textColor: selected ? AppColors.green : AppColors.dark,
          )
        ],
      ),
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
