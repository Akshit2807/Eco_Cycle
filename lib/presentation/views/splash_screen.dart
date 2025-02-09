import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_waste/core/router/app_router.dart';
import 'package:e_waste/widgets/custom_button.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CarouselSliderController con = CarouselSliderController();
  int ind = 0;
  List<String> imgList = [
    "assets/splash0.png",
    "assets/splash1.png",
    "assets/splash2.png",
    "assets/splash3.png",
  ];
  List<String> texts = [
    "♻️ Recycle Today for a Greener Tomorrow!",
    "📱 Dispose Responsibly, Protect the Planet!",
    "🌍 Turn Your E-Waste into a Sustainable Future!",
    "🔋 Reduce, Reuse, Recycle – Every Gadget Counts!"
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF1F1F1),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        textName: "Eco Cycle",
                        fontWeight: FontWeight.bold,
                        textColor: Color(0xff232323),
                        letterSpacing: 4,
                        textAlign: TextAlign.center,
                        fontSize: 32,
                      ),
                      Container(
                        height: 80,
                        width: 80,
                        color: Colors.red,
                        alignment: Alignment.center,
                        child: const CustomText(textName: "Logo"),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                CarouselSlider.builder(
                  carouselController: con,
                  itemCount: 4,
                  itemBuilder: (context, index, pageViewIndex) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                              fit: BoxFit.scaleDown,
                              image: AssetImage(imgList[index]))),
                    );
                  },
                  options: CarouselOptions(
                      autoPlay: true,
                      autoPlayCurve: Curves.easeInOut,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 500),
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      pageSnapping: true,
                      height: MediaQuery.of(context).size.height * 0.4,
                      scrollPhysics: const BouncingScrollPhysics(),
                      onPageChanged: (index, pageChangeReason) {
                        setState(() {
                          ind = index;
                        });
                      }),
                ),
                CustomText(
                  textName: texts[ind],
                  fontWeight: FontWeight.bold,
                  textColor: const Color(0xff232323),
                  letterSpacing: 2,
                  textAlign: TextAlign.center,
                  fontSize: 24,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                AnimatedSmoothIndicator(
                  activeIndex: ind,
                  count: 4,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 300),
                  effect: const WormEffect(
                    dotHeight: 16,
                    dotWidth: 16,
                    spacing: 16,
                    dotColor: Color(0xff232323),
                    activeDotColor: Color(0xff4CAF50),
                    type: WormType.normal,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                CustomButton(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    color: const Color(0xff4CAF50),
                    child: const CustomText(
                      textName: "Create an account",
                      textColor: Color(0xff232323),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(
                      textName: "Already have an account? ",
                      textColor: Color(0xff232323),
                      fontWeight: FontWeight.normal,
                      letterSpacing: 2,
                      textAlign: TextAlign.center,
                      fontSize: 14,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const CustomText(
                        textName: "Sign in",
                        fontWeight: FontWeight.normal,
                        letterSpacing: 2,
                        textColor: Color(0xff4CAF50),
                        textAlign: TextAlign.center,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
