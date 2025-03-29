import 'dart:convert';

import 'package:e_waste/core/router/app_router.dart';
import 'package:e_waste/core/services/decide_service.dart';
import 'package:e_waste/core/services/local_storage_service/secure_storage.dart';
import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_loader.dart';
import 'package:e_waste/core/utils/extensions.dart';
import 'package:e_waste/data/models/decision_model.dart';
import 'package:e_waste/presentation/components/custom_app_bar.dart';
import 'package:e_waste/presentation/screens/ai_classification/resell_screen.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class DecideScreen extends StatefulWidget {
  final String qns;
  const DecideScreen({super.key, required this.qns});

  @override
  State<DecideScreen> createState() => _DecideScreenState();
}

class _DecideScreenState extends State<DecideScreen> {
  late Future<Decision> _response;
  ScrollController controller = ScrollController();
  bool isRecycle = true;
  @override
  void initState() {
    _response = DecideService.getGuide(widget.qns, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Decision>(
        future: _response.whenComplete(() async {
          Future.delayed(const Duration(milliseconds: 100));
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            List<String> heading = snapshot.data!.guide.pointers.headings;
            List<String> description =
                snapshot.data!.guide.pointers.description;
            if (snapshot.data!.decision == "resell") {
              isRecycle = false;
            }
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: controller,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// App Bar
                    customAppBar(
                      isHome: false,
                      title: snapshot.data!.decision.capitalizeFirstOfEach,
                      rank: '12',
                      points: '40',
                      context: context,
                    ),
                    CustomText(
                      textName: snapshot.data!.guide.initials,
                      fontWeight: FontWeight.w500,
                      textColor: const Color(0xff232323),
                      letterSpacing: 1,
                      lineHeight: 1.2,
                      textAlign: TextAlign.left,
                      fontSize: 18,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: heading.length,
                        physics: const BouncingScrollPhysics(),
                        controller: controller,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: AppColors.green, width: 2)),
                              margin: const EdgeInsets.only(bottom: 24),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    textName: heading[index],
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.left,
                                    fontSize: 20,
                                    textColor: AppColors.green,
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  CustomText(
                                    textName: description[index],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    lineHeight: 1.2,
                                    textAlign: TextAlign.left,
                                    textColor: const Color(0xff232323),
                                  ),
                                ],
                              ));
                        }),
                    Row(
                      children: [
                        const SizedBox(
                          width: 24,
                        ),

                        /// Back Button
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                SecureStorageService()
                                    .deleteData("Base64Response");
                                SecureStorageService().deleteData("clickedImg");
                                SecureStorageService()
                                    .deleteData("QuestionsFromAI");
                                Get.toNamed(RouteNavigation.navScreenRoute);
                              },
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
                                isRecycle
                                    ? Get.offNamed(
                                        RouteNavigation.recycleScreenRoute,
                                        arguments: {
                                            'snapshot': snapshot,
                                          })
                                    : Get.offNamed(
                                        RouteNavigation.resellScreenRoute,
                                        arguments: {'snapshot': snapshot});
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
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          } else {
            return const Center(
              child: AppLoader(),
            );
          }
        },
      ),
    ));
  }
}
