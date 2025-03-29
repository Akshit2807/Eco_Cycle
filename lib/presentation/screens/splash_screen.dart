import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_waste/core/router/app_router.dart';
import 'package:e_waste/widgets/carousel_slider.dart';
import 'package:e_waste/widgets/custom_button.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:e_waste/widgets/percentage_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CarouselSliderController con = CarouselSliderController();
  final SplashController currentIndex = Get.put(SplashController());
  List<String> imgList = [
    "assets/splash/splash0.png",
    "assets/splash/splash1.png",
    "assets/splash/splash2.png",
    "assets/splash/splash3.png",
  ];
  List<String> texts = [
    "♻️ Recycle Today for a Greener Tomorrow!",
    "📱 Dispose Responsibly, Protect the Planet!",
    "🌍 Turn Your E-Waste into a Sustainable Future!",
    "🔋 Reduce, Reuse, Recycle – Every Gadget Counts!"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F1F1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 35),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// App Name
                    const CustomText(
                      textName: "Eco Cycle",
                      fontWeight: FontWeight.bold,
                      textColor: Color(0xff232323),
                      letterSpacing: 1,
                      textAlign: TextAlign.center,
                      fontSize: 32,
                    ),

                    /// App Logo
                    Image.asset(
                      "assets/logo.png",
                      height: 120,
                      width: 120,
                    )
                  ],
                ),
              ),
              PercentSizedBox.height(0.05),

              /// Top Image carousel
              AppCarouselSlider(
                con: con,
                imgList: imgList,
                currentIndex: currentIndex,
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              Obx(() => Column(
                    children: [
                      /// Changing Text
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: CustomText(
                          textName: texts[currentIndex.ind.value],
                          fontWeight: FontWeight.bold,
                          textColor: const Color(0xff232323),
                          letterSpacing: 1,
                          textAlign: TextAlign.center,
                          fontSize: 20,
                        ),
                      ),

                      /// Spacing
                      PercentSizedBox.height(0.05),

                      /// Dot Indicator
                      AnimatedSmoothIndicator(
                        activeIndex: currentIndex.ind.value,
                        count: 4,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 300),
                        effect: const WormEffect(
                          dotHeight: 12,
                          dotWidth: 12,
                          spacing: 16,
                          dotColor: Color(0xff232323),
                          activeDotColor: Color(0xff4CAF50),
                          type: WormType.normal,
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: double.maxFinite,
              ),

              /// Sign Up Button
              CustomButton(
                  onTap: () {
                    Get.toNamed(RouteNavigation.authScreenRoute);
                  },
                  color: const Color(0xff4CAF50),
                  child: const CustomText(
                    textName: "Create an account",
                    textColor: Color(0xff232323),
                  )),

              /// Spacing
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              //
              // //TODO: after routing page is still on signup page
              // /// Sign In Route
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const CustomText(
              //       textName: "Already have an account? ",
              //       textColor: Color(0xff232323),
              //       fontWeight: FontWeight.normal,
              //       letterSpacing: 2,
              //       textAlign: TextAlign.center,
              //       fontSize: 14,
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //         Get.offAllNamed(RouteNavigation.navScreenRoute);
              //       },
              //       child: const CustomText(
              //         textName: "Sign in",
              //         fontWeight: FontWeight.normal,
              //         letterSpacing: 2,
              //         textColor: Color(0xff4CAF50),
              //         textAlign: TextAlign.center,
              //         fontSize: 14,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
