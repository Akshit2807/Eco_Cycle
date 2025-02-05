import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;
  final VoidCallback? onTap;
  final Color? color;
  final Widget child;
  final List<BoxShadow>? boxShadow;
  const CustomButton(
      {super.key,
      this.height,
      this.width,
      this.radius,
      this.color,
      required this.child,
      this.boxShadow,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        height: height ?? 56,
        width: width ?? 376,
        decoration: BoxDecoration(
          boxShadow: boxShadow ?? [],
          borderRadius: BorderRadius.circular(radius ?? 16),
          color: color ?? Colors.black,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
