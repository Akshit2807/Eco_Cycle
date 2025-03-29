import 'dart:io';

import 'package:e_waste/core/services/local_storage_service/secure_storage.dart';
import 'package:e_waste/core/services/recycle_resell_service.dart';
import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_icons.dart';
import 'package:e_waste/core/utils/app_loader.dart';
import 'package:e_waste/core/utils/extensions.dart';
import 'package:e_waste/data/models/base_64_model.dart';
import 'package:e_waste/data/models/decision_model.dart';
import 'package:e_waste/presentation/components/custom_app_bar.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:e_waste/widgets/percentage_sized_box.dart';
import 'package:flutter/material.dart';

class ResellScreen extends StatefulWidget {
  final AsyncSnapshot<Decision> snapshot;
  const ResellScreen({super.key, required this.snapshot});

  @override
  State<ResellScreen> createState() => _ResellScreenState();
}

class _ResellScreenState extends State<ResellScreen> {
  late Future<List<dynamic>> res;
  @override
  void initState() {
    // TODO: implement initState
    res = RecycleResellService.getData(widget.snapshot.data!.decision, context);
    super.initState();
  }

  TextEditingController priceController = TextEditingController();
  TextEditingController desController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: res.whenComplete(() async {
        Future.delayed(const Duration(milliseconds: 100));
      }),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          File imageFile = File(snapshot.data![0]);
          Base64 obj = snapshot.data![1];
          return Material(
            color: AppColors.white,
            child: SingleChildScrollView(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top: 24, left: 12),
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 28,
                                      color:
                                          Colors.black.withValues(alpha: 0.2))
                                ],
                                borderRadius: BorderRadius.circular(360),
                                color: AppColors.white),
                            child: ImageIcon(
                              AssetImage(AppIcons.back),
                              color: AppColors.green,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 24, left: 12),
                          child: CustomText(
                            textName: "Sell To Marketplace",
                            fontWeight: FontWeight.w700,
                            textColor: AppColors.dark,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
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
                                  textName: obj.title,
                                  fontWeight: FontWeight.w400,
                                )),

                            /// Price
                            CustomText(
                              textName: "Price",
                              fontWeight: FontWeight.w700,
                              textColor: AppColors.dark,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Enter Price",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                              ),
                            ),
                            //Container(
                            // margin: const EdgeInsets.only(top: 6),
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 12, vertical: 12),
                            // decoration: BoxDecoration(
                            //     color: Colors.transparent,
                            //     border: Border.all(
                            //       color: AppColors.placeHolder,
                            //       strokeAlign: 1,
                            //     ),
                            //     borderRadius: BorderRadius.circular(12)),
                            // child: CustomText(
                            //   textName: obj.category,
                            //   fontWeight: FontWeight.w400,
                            // )),
                          ],
                        )
                      ],
                    ),
                  ),
                  PercentSizedBox.height(0.06),

                  /// Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          textName: "Description",
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 400,
                          child: TextField(
                            controller: desController,
                            keyboardType: TextInputType.text,
                            expands: true,
                            maxLines: null,
                            decoration: InputDecoration(
                              maintainHintHeight: false,
                              hintText: "Enter Description of Product",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                        ),
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
                            onPressed: () {
                              SecureStorageService()
                                  .deleteData("Base64Response");
                              SecureStorageService().deleteData("clickedImg");
                              SecureStorageService()
                                  .deleteData("QuestionsFromAI");
                              Navigator.pop(context);
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

                      /// Sell Button
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {},
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
                                textName: "Sell",
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
    );
  }
}
