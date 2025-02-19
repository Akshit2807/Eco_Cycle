import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_icons.dart';
import 'package:e_waste/presentation/dashboard/community_screen.dart';
import 'package:e_waste/presentation/dashboard/home_screen.dart';
import 'package:e_waste/presentation/dashboard/marketplace_screen.dart';
import 'package:e_waste/presentation/dashboard/reward_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RxInt selectedIndex = 0.obs;
    final PageController pageController = PageController(initialPage: 0);
    const List pages = [
      HomeScreen(),
      CommunityScreen(),
      MarketplaceScreen(),
      RewardScreen()
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,

        /// Navigation Screens
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
          child: PageView.builder(
              onPageChanged: (int newIndex) {
                selectedIndex.value = newIndex;
              },
              itemCount: 4,
              controller: pageController,
              itemBuilder: (BuildContext context, int index) {
                return Obx(() => pages[selectedIndex.value]);
              }),
        ),

        /// Bottom Bar Centre Button
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: const CustomBottomNavigationCentreButton(),

        /// Bottom Nav Bar
        bottomNavigationBar: CustomBottomNavigation(
          selectedIndex: selectedIndex,
        ),
      ),
    );
  }
}

//TODO: Convert into class
class CustomBottomNavigation extends StatelessWidget {
  final RxInt selectedIndex;

  const CustomBottomNavigation({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipPath(
          clipper: CustomBottomBarClipper(),
          child: Container(
            height: kBottomNavigationBarHeight + 10,
            width: double.infinity,
            color: AppColors.placeHolder,
          ),
        ),
        ClipPath(
          clipper: CustomBottomBarClipper(),
          child: Obx(
            () => BottomNavigationBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              showSelectedLabels: true,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              currentIndex: selectedIndex.value >= 2
                  ? selectedIndex.value + 1
                  : selectedIndex.value,
              onTap: (int newIndex) {
                if (newIndex == 2) return; // Skip SizedBox index
                selectedIndex.value = newIndex > 2 ? newIndex - 1 : newIndex;
              },
              selectedItemColor: AppColors.green,
              unselectedItemColor: AppColors.placeHolder,
              items: [
                BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage(AppIcons.home), size: 30),
                    label: "Home"),
                BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage(AppIcons.community), size: 30),
                    label: "Community"),
                const BottomNavigationBarItem(
                    icon: SizedBox.shrink(), label: ''), // Spacer
                BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage(AppIcons.marketplace), size: 30),
                    label: "Marketplace"),
                BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage(AppIcons.rewards), size: 30),
                    label: "Rewards")
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom Clipper with Smoother, More Rounded Cutout
class CustomBottomBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    double radius = 24; // Maintain radius
    double deepness = 34; // Increase this for a deeper cutout

    Path path = Path();
    path.lineTo((width / 2) - (radius * 2), 0);

    // Create a deeper notch by lowering the middle control point
    path.quadraticBezierTo(
        width / 2 - radius, deepness, width / 2, deepness); // Left curve
    path.quadraticBezierTo(width / 2 + radius, deepness,
        (width / 2) + (radius * 2), 0); // Right curve

    path.lineTo(width, 0);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomBottomNavigationCentreButton extends StatefulWidget {
  const CustomBottomNavigationCentreButton({super.key});

  @override
  State<CustomBottomNavigationCentreButton> createState() =>
      _CustomBottomNavigationCentreButtonState();
}

class _CustomBottomNavigationCentreButtonState
    extends State<CustomBottomNavigationCentreButton>
    with TickerProviderStateMixin {
  bool _isDialOpen = false;

  late AnimationController _controller;

  // Define animations for each child FAB
  late Animation<double> _childAnimation1;

  late Animation<double> _childAnimation2;

  late Animation<double> _childAnimation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Create curved animations for smooth movement
    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    // Configure animations for each child with different angles
    _childAnimation1 = Tween(begin: 0.0, end: 1.0).animate(curve);
    _childAnimation2 = Tween(begin: 0.0, end: 1.0).animate(curve);
    _childAnimation3 = Tween(begin: 0.0, end: 1.0).animate(curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleDial() {
    if (_isDialOpen) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isDialOpen = !_isDialOpen;
    });
  }

  Widget _buildChild(Animation<double> animation, IconData icon,
      VoidCallback onTap, double angle) {
    const double distance = 80.0; // Distance from center button

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final x = distance * math.cos(angle) * animation.value;
        final y = distance * math.sin(angle) * animation.value;

        return Positioned(
          right: MediaQuery.of(context).size.width / 2 - 28 + x,
          bottom: 48 - y, // Adjust this value based on your bottom nav height
          child: Transform.scale(
            scale: animation.value,
            child: child,
          ),
        );
      },
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(360), // Ensures it's circular
        ),
        heroTag: null,
        backgroundColor: const Color(0xFF4CAF50),
        mini: false,
        onPressed: onTap,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Child FABs
        _buildChild(
          _childAnimation1,
          Icons.camera_alt,
          () => print('Camera tapped'),
          (-math.pi / 3) + 0.35, // -60 degrees
        ),

        _buildChild(
          _childAnimation2,
          Icons.edit,
          () => print('Edit tapped'),
          -math.pi / 2, // -90 degrees
        ),
        _buildChild(
          _childAnimation3,
          Icons.shopping_bag,
          () => print('Shopping tapped'),
          (-2 * math.pi / 3) - 0.35, // -120 degrees
        ),
        // Main FAB
        Positioned(
          bottom: 50,
          child: FloatingActionButton(
            mini: false,
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(360), // Ensures it's circular
            ),
            onPressed: _toggleDial,
            child: AnimatedIcon(
              color: Colors.white,
              size: 20,
              icon: AnimatedIcons.menu_close,
              progress: _controller,
            ),
          ),
        ),
      ],
    );
  }
}
