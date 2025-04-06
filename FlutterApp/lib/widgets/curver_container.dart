import 'package:flutter/material.dart';

class ConcaveContainer extends StatelessWidget {
  final Widget? child;
  final double height;
  final Color backgroundColor;
  final Color borderColor;
  final EdgeInsets? padding;
  const ConcaveContainer({
    Key? key,
    this.child,
    this.height = 400,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipPath(
        clipper: ConcaveContainerClipper(),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          child: child,
        ),
      ),
    );
  }
}

class ConcaveContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left
    path.moveTo(0, 0);

    // Draw the concave curve at the top
    path.quadraticBezierTo(
      size.width / 2, // Control point x (middle of width)
      80, // Control point y (depth of curve)
      size.width, // End point x
      0, // End point y
    );

    // Complete the rectangle
    path.lineTo(size.width, size.height); // Right side
    path.lineTo(0, size.height); // Bottom
    path.lineTo(0, 0); // Left side

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
