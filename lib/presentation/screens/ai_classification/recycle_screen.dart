import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:e_waste/core/router/app_router.dart';
import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/date_picker.dart';
import 'package:e_waste/core/utils/extensions.dart';
import 'package:e_waste/data/models/decision_model.dart';
import 'package:e_waste/presentation/components/custom_app_bar.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scroll_screenshot/scroll_screenshot.dart';

class RecycleScreen extends StatefulWidget {
  final AsyncSnapshot<Decision> snapshot;
  const RecycleScreen({super.key, required this.snapshot});

  @override
  State<RecycleScreen> createState() => _RecycleScreenState();
}

class _RecycleScreenState extends State<RecycleScreen> {
  bool tappedPickup = false;
  ScrollController controller = ScrollController();
  final TabController tabController = Get.put(TabController());
  final GlobalKey globalKey = GlobalKey();

  bool tappedBook = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(builder: (context, constraints) {
          return GetBuilder(
              init: tabController,
              builder: (ctrl) {
                Map<String, String> locations = ctrl.isLogin
                    ? {
                        "Surya Roshni Ltd": "4.2 km",
                        "Unique Eco Recycle": "7.8 km",
                        "Prometheus Recycling": "12.3 km",
                        "Moonstar Enterprises": "9.1 km",
                        "Excellent Services": "8.0 km",
                        "Gayatri Incorporation": "3.7 km",
                        "Satguru Systems": "6.9 km",
                        "Smart Services": "10.4 km",
                      }
                    : {
                        "Satguru Systems": "6.9 km",
                        "Smart Services": "10.4 km",
                        "Star Mobile Service Center": "2.8 km",
                        "Yash Enterprises": "11.2 km",
                        "Municipal Corporation": "1.5 km",
                        "Unitech Info System": "6.4 km",
                      };
                final keys = locations.keys.toList();
                return SingleChildScrollView(
                  controller: controller,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// App Bar
                        customAppBar(
                          isHome: false,
                          title: widget
                              .snapshot.data!.decision.capitalizeFirstOfEach,
                          rank: '12',
                          points: '40',
                          context: context,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomText(
                          textName: "Nearby locations to dispose E-Waste",
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          textColor: AppColors.green,
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        /// Sliding tab
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _authTab('Schedule Pickup', !ctrl.isLogin,
                                false), // Sign Up tab
                            _authTab('Book appointment', ctrl.isLogin,
                                true), // Login tab
                          ],
                        ),

                        const SizedBox(height: 10),
                        ListView.builder(
                            itemCount: locations.length,
                            shrinkWrap: true,
                            controller: controller,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final title = keys[index];
                              final distance = locations[title]!;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    final String? selectedDate =
                                        await pickDateTime(context);

                                    if (selectedDate != null) {
                                      showOverlay(
                                        context,
                                        AppColors.white,
                                        AppColors.green,
                                        !ctrl.isLogin
                                            ? "Pickup Scheduled"
                                            : "Appointment Booked",
                                        !ctrl.isLogin
                                            ? "Your Pickup is scheduled on the date - $selectedDate"
                                            : "Your appointment is booked on the date - $selectedDate",
                                      );
                                    }
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.location_on_rounded,
                                      color: AppColors.dark,
                                    ),
                                    title: CustomText(
                                      textName: title,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      textColor: AppColors.dark,
                                    ),
                                    trailing: CustomText(
                                      textName: distance,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      textColor: AppColors.dark,
                                    ),
                                    tileColor:
                                        AppColors.green.withValues(alpha: 0.5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                  ),
                                ),
                              );
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                );
              });
        }));
  }

  // Builds the tab selector for Login/Signup with styling
  Widget _authTab(String text, bool active, bool isLoginTile) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.41,
      child: GestureDetector(
        onTap: tabController.toggleAuthMode,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.green : AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: isLoginTile
                  ? const Radius.circular(0)
                  : const Radius.circular(10),
              topRight: isLoginTile
                  ? const Radius.circular(10)
                  : const Radius.circular(0),
              bottomRight: isLoginTile
                  ? const Radius.circular(10)
                  : const Radius.circular(0),
              bottomLeft: isLoginTile
                  ? const Radius.circular(0)
                  : const Radius.circular(10),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                fontSize: 16,
                color: active ? Colors.white : Colors.green,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class TabController extends GetxController {
  bool isLogin = false;

  // Toggles between Login and Signup screens
  toggleAuthMode() {
    isLogin = !isLogin;
    update();
  }
}

void showOverlay(BuildContext context, Color bg, Color accent, String title,
    String subtitle) {
  final GlobalKey previewContainer = GlobalKey();

  var dialog = AlertDialog(
    backgroundColor: bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(25.0),
      ),
    ),
    content: IntrinsicHeight(
      child: Column(
        children: [
          RepaintBoundary(
            key: previewContainer,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Center(
                  child: CustomText(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    maxLines: 10,
                    textColor: AppColors.dark,
                    textName: title,
                  ),
                ),
                Lottie.asset(
                  'assets/done.json',
                  repeat: false,
                  height: MediaQuery.of(context).size.width * 0.6,
                  width: double.maxFinite,
                ),
                Center(
                  child: CustomText(
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 10,
                    textColor: accent,
                    textName: subtitle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.offAllNamed(RouteNavigation.homeScreenRoute);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                fixedSize: const Size(double.maxFinite, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: AppColors.lightGreen,
              ),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: CustomText(
                  textName: "Okay",
                  textColor: AppColors.dark.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: ContinueButton(
              globalKey: previewContainer,
            ),
          ),
        ],
      ),
    ),
  );

  showDialog(context: context, builder: (BuildContext context) => dialog);
}

Future<File> convertToFile(Uint8List imageBytes, String fileName) async {
  final directory =
      await getTemporaryDirectory(); // or getApplicationDocumentsDirectory()
  final filePath = '${directory.path}/$fileName.png';
  final file = File(filePath);
  await file.writeAsBytes(imageBytes);
  return file;
}

class ContinueButton extends StatefulWidget {
  final GlobalKey globalKey;

  const ContinueButton({super.key, required this.globalKey});

  @override
  State<ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<ContinueButton> {
  bool isLoading = false;

  Future<void> handleContinue() async {
    setState(() => isLoading = true);

    String? base64 = await _captureAndSaveScreenshot(widget.globalKey);

    if (base64 != null) {
      File file = await convertToFile(
        base64Decode(base64),
        "screenshot_${DateTime.now().millisecondsSinceEpoch}",
      );

      Navigator.pop(context); // Close the dialog

      Get.offAllNamed(
        RouteNavigation.postBlogScreenRoute,
        arguments: {'path': file.path, 'img': file},
      );
    } else {
      log("Screenshot capture failed.");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : handleContinue,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        fixedSize: const Size(double.maxFinite, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: AppColors.green,
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : FittedBox(
              fit: BoxFit.fitWidth,
              child: CustomText(
                textName: "Share With Community",
                textColor: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
    );
  }
}

Future<String?> _captureAndSaveScreenshot(GlobalKey globalKey) async {
  String? base64String =
      await ScrollScreenshot.captureAndSaveScreenshot(globalKey);
  return base64String;
}
