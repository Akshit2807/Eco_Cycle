import 'package:carousel_slider/carousel_controller.dart';
import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/presentation/components/custom_app_bar.dart';
import 'package:e_waste/widgets/carousel_slider.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeScreen({
    super.key,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    List<String> imgList = [
      "assets/home/1.png",
      "assets/home/2.png",
      "assets/home/3.png",
      "assets/home/4.png",
    ];
    CarouselSliderController con = CarouselSliderController();
    final SplashController currentIndex = Get.put(SplashController());
    return SafeArea(
      child: Column(
        children: [
          /// App Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: customAppBar(
              isHome: true,
              title: "Eco Cycle",
              rank: '12',
              points: '40',
              scaffoldKey: scaffoldKey,
              prf: const Image(image: AssetImage("assets/prf.png")),
              context: context,
            ),
          ),
          const SizedBox(
            height: 24,
          ),

          /// Top Image carousel
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 0),
                  blurRadius: 24,
                  color: Colors.black.withOpacity(0.1))
            ]),
            child: AppCarouselSlider(
              con: con,
              imgList: imgList,
              currentIndex: currentIndex,
              height: MediaQuery.of(context).size.height * 0.21,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            height: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: CustomText(
                    textName:
                        "Bravo! You’ve recycled 18.5 kg. Just 1.5 kg more to unlock your next reward!",
                    fontWeight: FontWeight.w500,
                    textColor: Color(0xff232323),
                    maxLines: 10,
                    textAlign: TextAlign.left,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                      "85%",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.2,
                      child: const CircularProgressIndicator(
                        strokeWidth: 10,
                        value: 0.85,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
