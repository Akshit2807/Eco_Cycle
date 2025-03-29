import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppCarouselSlider extends StatefulWidget {
  final CarouselSliderController con;
  final List<String> imgList;
  final SplashController currentIndex;
  final double height;
  const AppCarouselSlider(
      {super.key,
      required this.con,
      required this.imgList,
      required this.currentIndex,
      required this.height});

  @override
  State<AppCarouselSlider> createState() => _AppCarouselSliderState();
}

class _AppCarouselSliderState extends State<AppCarouselSlider> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      carouselController: widget.con,
      itemCount: widget.imgList.length,
      itemBuilder: (context, index, pageViewIndex) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(widget.imgList[index]))),
        );
      },
      options: CarouselOptions(
          autoPlay: true,
          autoPlayCurve: Curves.easeInOut,
          autoPlayAnimationDuration: const Duration(milliseconds: 500),
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: false,
          pageSnapping: true,
          height: widget.height,
          scrollPhysics: const BouncingScrollPhysics(),
          onPageChanged: (index, pageChangeReason) {
            widget.currentIndex.change(index);
          }),
    );
  }
}

class SplashController extends GetxController {
  var ind = 0.obs;
  change(int newIndex) {
    ind.value = newIndex;
  }
}
