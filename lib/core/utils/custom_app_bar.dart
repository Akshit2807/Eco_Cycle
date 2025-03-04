import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_icons.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';

Row customAppBar({
  required BuildContext context,
  required bool isHome,
  required String title,
  required String rank,
  required String points,
  Widget? prf,
  GlobalKey<ScaffoldState>? scaffoldKey,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CustomText(
        textName: title,
        fontSize: screenWidth * 0.06, // Adjusts dynamically
        fontWeight: FontWeight.bold,
        maxLines: 1,
      ),
      const Spacer(),
      if (isHome) ...[
        _buildStatContainer(
          screenWidth,
          icon: AppIcons.leaderboard,
          text: rank,
        ),
        SizedBox(width: screenWidth * 0.02),
        _buildStatContainer(
          screenWidth,
          icon: AppIcons.medal,
          text: points,
        ),
        SizedBox(width: screenWidth * 0.03),
        SizedBox(width: screenWidth * 0.03),
      ],
      GestureDetector(
        onTap: () {
          scaffoldKey?.currentState?.openDrawer();
        },
        child: CircleAvatar(
          radius: screenWidth * 0.07, // Dynamic size
          backgroundColor: Colors.transparent,
          child: prf,
        ),
      ),
    ],
  );
}

Widget _buildStatContainer(double screenWidth,
    {required String icon, required String text}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: screenWidth * 0.015,
      vertical: screenWidth * 0.007,
    ),
    width: screenWidth * 0.15, // Scalable width
    height: screenWidth * 0.07, // Scalable height
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.green, width: 2),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      children: [
        Image.asset(icon, width: screenWidth * 0.05), // Dynamic icon size
        const Spacer(),
        CustomText(
          textName: text,
          fontSize: screenWidth * 0.03, // Scalable font size
          fontWeight: FontWeight.w400,
        ),
      ],
    ),
  );
}
