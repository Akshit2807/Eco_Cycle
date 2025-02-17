import 'package:e_waste/core/utils/app_colors.dart' show AppColors;
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: const Center(
        child: CustomText(textName: 'Reward Screen'),
      ),
    );
  }
}
