import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_icons.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

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
        child: ClipOval(
          child: firebaseUser?.photoURL != null
              ? Image.network(
                  firebaseUser!.photoURL!,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.width * 0.1,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://imgs.search.brave.com/prpbPTMAYp2IA5lapKLeVJlEtZBzWn_GGlcchFotrkU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJzLmNvbS9p/bWFnZXMvZmVhdHVy/ZWQvbWluZWNyYWZ0/LW1lbWUtcGljdHVy/ZXMteW14d2U2dHk5/N2h2b2JrMC5qcGc',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.width * 0.1,
                    );
                  },
                )
              : Image.network(
                  'https://imgs.search.brave.com/prpbPTMAYp2IA5lapKLeVJlEtZBzWn_GGlcchFotrkU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJzLmNvbS9p/bWFnZXMvZmVhdHVy/ZWQvbWluZWNyYWZ0/LW1lbWUtcGljdHVy/ZXMteW14d2U2dHk5/N2h2b2JrMC5qcGc',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.12,
                  height: MediaQuery.of(context).size.width * 0.12,
                ),
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
