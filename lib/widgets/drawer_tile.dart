import 'package:e_waste/widgets/percentage_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/controller/Drawer/drawer_ctrl.dart';
import '../core/utils/app_colors.dart';
import 'custom_text.dart';

Widget buildDrawerTile(
    String icon, String title, int index, DrawerControllerX controller,
    {VoidCallback? onTileTap}) {
  return GestureDetector(
    onTap: () {
      controller.updateIndex(index); // Update selected index
      if (onTileTap != null) onTileTap();
    },
    child: Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PercentSizedBox.height(0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ImageIcon(
                AssetImage(icon),
                size: 24,
                color: AppColors.dark,
              ),
              // const SizedBox(width: 16),
              PercentSizedBox.width(0.05),
              CustomText(
                textName: title,
                fontWeight: FontWeight.w500,
                fontSize: 20,
                textColor: AppColors.dark,
              ),
            ],
          ),
          Divider(
            color: AppColors.dark,
            thickness: 0.5,
            indent: 40,
            endIndent: 16,
          ),
          PercentSizedBox.height(0.015),
        ],
      ),
    ),
  );
}
