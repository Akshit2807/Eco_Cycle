import 'package:e_waste/widgets/percentage_sized_box.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

class CustomBottomNavigation extends StatefulWidget {
  RxInt selectedIndex;

  CustomBottomNavigation({super.key, required this.selectedIndex});

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomBottomBarClipper(),
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: widget.selectedIndex.value,
        onTap: (int newIndex) {
          widget.selectedIndex.value = newIndex;
        },
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.people, color: Colors.grey, size: 30),
              label: "Home"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.storefront, color: Colors.green, size: 30),
              label: "Store"),
          BottomNavigationBarItem(
              icon: PercentSizedBox.width(0.04), label: "Store"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart, color: Colors.grey, size: 30),
              label: "Cart"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events, color: Colors.grey, size: 30),
              label: "Events")
        ],
      ),
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
    double deepness = 40; // Increase this for a deeper cutout

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
