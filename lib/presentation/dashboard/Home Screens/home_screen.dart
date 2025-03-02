import 'package:carousel_slider/carousel_controller.dart';
import 'package:e_waste/core/utils/custom_app_bar.dart';
import 'package:e_waste/widgets/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        ],
      ),
    );
  }
}
