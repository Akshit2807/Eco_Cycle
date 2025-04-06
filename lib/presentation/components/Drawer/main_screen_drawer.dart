import 'package:e_waste/core/services/local_storage_service/hive_service.dart';
import 'package:e_waste/core/utils/extensions.dart';
import 'package:e_waste/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controller/Drawer/drawer_ctrl.dart';
import '../../../core/services/local_storage_service/secure_storage.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../../../data/models/user_model.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/drawer_tile.dart';

Drawer myDrawer(BuildContext context, UserModel? user) {
  final DrawerControllerX controller = Get.put(DrawerControllerX());
  // final userController = Get.put(UserController());
  final SecureStorageService secureStorageService = SecureStorageService();
  final HiveService hiveService = HiveService();
  final UserRepository userRepository = UserRepository();
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  return Drawer(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
    ),
    child: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xFFEFFBF1), Color(0xFF9BE7C4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
        ),
        Column(
          children: [
            const SizedBox(height: 24),
            ClipOval(
              child: firebaseUser?.photoURL != null
                  ? Image.network(
                      firebaseUser!.photoURL!,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.4,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          'https://imgs.search.brave.com/prpbPTMAYp2IA5lapKLeVJlEtZBzWn_GGlcchFotrkU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJzLmNvbS9p/bWFnZXMvZmVhdHVy/ZWQvbWluZWNyYWZ0/LW1lbWUtcGljdHVy/ZXMteW14d2U2dHk5/N2h2b2JrMC5qcGc',
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.width * 0.4,
                        );
                      },
                    )
                  : Image.network(
                      'https://imgs.search.brave.com/prpbPTMAYp2IA5lapKLeVJlEtZBzWn_GGlcchFotrkU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJzLmNvbS9p/bWFnZXMvZmVhdHVy/ZWQvbWluZWNyYWZ0/LW1lbWUtcGljdHVy/ZXMteW14d2U2dHk5/N2h2b2JrMC5qcGc',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.4,
                    ),
            ),
            const SizedBox(height: 24),
            Center(
              child: CustomText(
                textName: user?.username.capitalizeFirstOfEach ?? "Not fetched",
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      //Home
                      buildDrawerTile(AppIcons.home, "Home", 0, controller,
                          onTileTap: () {
                        print(secureStorageService.getData('currentUserName'));
                      }),
                      //EditProfile
                      buildDrawerTile(
                          AppIcons.edit, "Edit Profile", 1, controller),
                      //Bookmarks
                      buildDrawerTile(
                          AppIcons.bookmark2, "Bookmarks", 2, controller),
                      //FAQ
                      buildDrawerTile(AppIcons.faq, "FAQ", 3, controller,
                          onTileTap: () {
                        Get.toNamed("/faq");
                      }),
                      //Help
                      buildDrawerTile(
                          AppIcons.help, "Help & Support", 5, controller,
                          onTileTap: () {
                        Get.toNamed("/help");
                      }),
                      //Settings
                      buildDrawerTile(
                          AppIcons.setting, "Settings", 7, controller,
                          onTileTap: () {
                        Get.toNamed("/settings");
                      }),
                      //Logout
                      buildDrawerTile(AppIcons.logout, "Logout", 8, controller,
                          onTileTap: () {
                        AuthViewModel().signOut(context);
                      }),
                      const Spacer(),
                      CustomText(
                        textName: " V 1.0.5",
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        textColor: AppColors.green,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
