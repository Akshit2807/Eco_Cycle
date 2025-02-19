import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_icons.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';

Row customAppBar(
    {required bool isHome,
    required String title,
    required String rank,
    required String points,
    required Image prf}) {
  return Row(
    children: [
      CustomText(
        textName: title,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      const Spacer(),
      if (isHome)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          width: 56,
          height: 28,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.green, width: 3),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            children: [
              Image.asset(AppIcons.leaderboard),
              const Spacer(),
              CustomText(
                textName: rank,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              )
            ],
          ),
        ),
      if (isHome)
        const SizedBox(
          width: 6,
        ),
      if (isHome)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          width: 56,
          height: 28,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.green, width: 3),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            children: [
              Image.asset(AppIcons.medal),
              const Spacer(),
              CustomText(
                textName: points,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              )
            ],
          ),
        ),
      if (isHome)
        const SizedBox(
          width: 8,
        ),
      CircleAvatar(radius: 28, child: prf),
    ],
  );
}
