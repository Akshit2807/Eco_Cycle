import 'package:e_waste/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: Center(
        child: Lottie.asset('assets/loader.json',
            repeat: true, height: double.maxFinite, width: double.maxFinite),
      ),
    );
  }
}
