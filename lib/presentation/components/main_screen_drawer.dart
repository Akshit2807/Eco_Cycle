import 'package:flutter/material.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/app_icons.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/drawer_tile.dart';

Drawer myDrawer(BuildContext context) {
  return Drawer(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(24), bottomRight: Radius.circular(24))),
    child: Stack(
      children: [
        Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0, 0.47],
              colors: [AppColors.green, Colors.white],
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.2,
              // Dynamic size
              child: const Image(
                image: AssetImage("assets/prf.png"),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Center(
              child: CustomText(
                textName: "Sarthak Patil",
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Expanded(
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(24),
                        topLeft: Radius.circular(24))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDrawerTile(AppIcons.home, "Home", true),
                      buildDrawerTile(AppIcons.edit, "Edit Profile", false),
                      buildDrawerTile(AppIcons.bookmark2, "Bookmarks", false),
                      buildDrawerTile(AppIcons.faq, "FAQ", false),
                      buildDrawerTile(
                          AppIcons.bill, "Billing & Address", false),
                      buildDrawerTile(AppIcons.help, "Help", false),
                      buildDrawerTile(AppIcons.sf, "S&F", false),
                      buildDrawerTile(AppIcons.setting, "Settings", false),
                      buildDrawerTile(
                        AppIcons.logout,
                        "Logout",
                        false,
                        onTileTap: () {
                          AuthViewModel().signOut(context);
                        },
                      ),
                      CustomText(
                        textName: " V 1.253.450",
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        textColor: AppColors.green,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    ),
  );
}
