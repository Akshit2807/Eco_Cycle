import 'dart:io';

import 'package:e_waste/core/router/app_router.dart';
import 'package:e_waste/core/services/camera_service.dart';
import 'package:e_waste/core/services/local_storage_service/secure_storage.dart';
import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_loader.dart';
import 'package:e_waste/data/models/base_64_model.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_icons.dart';
import '../../../widgets/percentage_sized_box.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late Future<Base64> _response;
  late String filePath;

  @override
  void initState() {
    _response = CameraService.getCategory(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: FutureBuilder<Base64>(
          future: _response.whenComplete(() async {
            filePath = (await SecureStorageService().getData("clickedImg"))!;
            Future.delayed(const Duration(milliseconds: 100));
          }),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              File imageFile = File(filePath);
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Back Button
                    GestureDetector(
                      onTap: () {
                        SecureStorageService().deleteData("Base64Response");
                        SecureStorageService().deleteData("clickedImg");
                        SecureStorageService().deleteData("QuestionsFromAI");
                        Navigator.pop(context);
                      },
                      child: Container(
                          margin: const EdgeInsets.only(top: 24, left: 12),
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 28,
                                    color: Colors.black.withValues(alpha: 0.2))
                              ],
                              borderRadius: BorderRadius.circular(360),
                              color: AppColors.white),
                          child: ImageIcon(
                            AssetImage(AppIcons.back),
                            color: AppColors.green,
                          )),
                    ),
                    PercentSizedBox.height(0.04),

                    /// Image
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image(
                                image: FileImage(imageFile),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Title
                              CustomText(
                                textName: "Title",
                                fontWeight: FontWeight.w700,
                                textColor: AppColors.dark,
                              ),
                              Container(
                                  margin:
                                      const EdgeInsets.only(top: 6, bottom: 20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: AppColors.placeHolder,
                                        strokeAlign: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: CustomText(
                                    textName: snapshot.data!.title,
                                    fontWeight: FontWeight.w400,
                                  )),

                              /// Category
                              CustomText(
                                textName: "Category",
                                fontWeight: FontWeight.w700,
                                textColor: AppColors.dark,
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: AppColors.placeHolder,
                                        strokeAlign: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: CustomText(
                                    textName: snapshot.data!.category,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                    PercentSizedBox.height(0.06),

                    /// description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            textName: "Description",
                            fontWeight: FontWeight.w700,
                          ),
                          Container(
                              width: double.maxFinite,
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: AppColors.placeHolder,
                                    strokeAlign: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12)),
                              alignment: Alignment.center,
                              child: CustomText(
                                textName: snapshot.data!.desc,
                                fontWeight: FontWeight.w400,
                                textColor: AppColors.dark,
                              )),
                        ],
                      ),
                    ),
                    PercentSizedBox.height(0.06),

                    /// Buttons
                    Row(
                      children: [
                        const SizedBox(
                          width: 24,
                        ),

                        /// Back Button
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                fixedSize: const Size(double.maxFinite, 56),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: AppColors.green,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12)),
                                backgroundColor: Colors.transparent,
                              ),
                              child: CustomText(
                                textName: "Back",
                                textColor: AppColors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                        ),
                        const SizedBox(
                          width: 24,
                        ),

                        /// Continue Button
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed(RouteNavigation.quetionsScreenRoute,
                                    arguments: {
                                      'title': snapshot.data!.title,
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                fixedSize: const Size(double.maxFinite, 56),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                backgroundColor: AppColors.green,
                              ),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: CustomText(
                                  textName: "Continue",
                                  textColor: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Text("Something went wrong");
            } else {
              return const Center(
                child: AppLoader(),
              );
            }
          },
        ),
      ),
    );
  }
}
