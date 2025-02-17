import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomText(textName: 'Home Screen'),
    );
  }
}
