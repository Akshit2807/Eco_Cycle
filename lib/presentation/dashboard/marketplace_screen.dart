import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: const Center(
        child: CustomText(textName: 'Marketplace Screen'),
      ),
    );
  }
}
