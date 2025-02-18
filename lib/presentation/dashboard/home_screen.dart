import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_icons.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const CustomText(
              textName: 'Eco Cycle',
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            const Spacer(),
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
                  const CustomText(
                    textName: "12",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 6,
            ),
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
                  const CustomText(
                    textName: "40",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const CircleAvatar(
              radius: 28,
              child: Image(image: AssetImage("assets/prf.png")),
            )
          ],
        ),
        const CustomText(textName: 'Home Screen'),
      ],
    );
  }
}
