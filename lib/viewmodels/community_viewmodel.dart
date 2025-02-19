import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_icons.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class communityViews {
  Container buildBlogCard() {
    return Container(
      height: 264,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          /// Image
          Image.asset("assets/blog.png"),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: CustomText(
              textName:
                  "Small e-waste often contains hazardous materials like lead, mercury, and cadmium, which can harm the environment if not disposed of properly Small e-waste often contains hazardous materials like lead, mercury",
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: ImageIcon(AssetImage(AppIcons.up)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: ImageIcon(AssetImage(AppIcons.comment)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: ImageIcon(AssetImage(AppIcons.bookmark)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: ImageIcon(AssetImage(AppIcons.share)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSidebarIcon(String icon, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Colors.grey.shade300 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ImageIcon(
        AssetImage(icon),
        color: isActive ? Colors.black : AppColors.placeHolder,
        size: 24,
      ),
    );
  }
}
