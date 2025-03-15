import 'package:flutter/material.dart';

import '../core/utils/app_colors.dart';
import 'custom_text.dart';

Widget buildDrawerTile(String icon, String title, bool selected,
    {VoidCallback? onTileTap}) {
  return GestureDetector(
    onTap: () {
      if (onTileTap != null) {
        onTileTap();
        selected = true;
      } else {
        print("No action");
      }
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ImageIcon(
          AssetImage(icon),
          size: 24,
          color: selected ? AppColors.green : AppColors.dark,
        ),
        const SizedBox(
          width: 16,
        ),
        CustomText(
          textName: title,
          fontWeight: FontWeight.w500,
          fontSize: 20,
          textColor: selected ? AppColors.green : AppColors.dark,
        )
      ],
    ),
  );
}
