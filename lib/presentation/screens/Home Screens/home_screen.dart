import 'dart:math';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/extensions.dart';
import 'package:e_waste/data/models/user_model.dart';
import 'package:e_waste/data/repositories/user_repository.dart';
import 'package:e_waste/presentation/components/custom_app_bar.dart';
import 'package:e_waste/viewmodels/marketplace_viewmodel.dart';
import 'package:e_waste/widgets/carousel_slider.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final UserModel? user;
  const HomeScreen({
    super.key,
    required this.scaffoldKey,
    required this.user,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<int> _percentageAnimation;

  final double targetPercentage = 86.0; // The target percentage to animate to

  @override
  void initState() {
    super.initState();

    // Create animation controller with 2 second duration
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Create animation for the progress arc (0.0 to targetPercentage/100)
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: targetPercentage / 100,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Create animation for the percentage text (0 to targetPercentage)
    _percentageAnimation = IntTween(
      begin: 0,
      end: targetPercentage.round(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation when the widget is built
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String getGreeting() {
    var hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning ☀️";
    } else if (hour >= 12 && hour < 16) {
      return "Good Afternoon 🌤️";
    } else {
      return "Good Evening 🌙";
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    final List<ProductItem> _products = [
      ProductItem(
        imageUrl: 'https://i.imgur.com/msoCP2s.jpg',
        price: 5000,
        title: 'Apple Airpods',
      ),
      ProductItem(
        imageUrl: 'https://i.imgur.com/OW5KuV9.jpg',
        price: 1200,
        title: 'Logitech Mouse',
      ),
      ProductItem(
        imageUrl: 'https://i.imgur.com/pGGI22r.jpg',
        price: 35000,
        title: 'Sony Camera',
      ),
      ProductItem(
        imageUrl: 'https://i.imgur.com/LzcXm2g.jpg',
        price: 41000,
        title: 'Iphone 14 Pro',
      ),
      ProductItem(
        imageUrl: 'https://i.imgur.com/1ohSHK6.jpg',
        price: 3490,
        title: 'Wireless Controller',
      ),
      ProductItem(
        imageUrl: 'https://i.imgur.com/ThxaZ14.jpg',
        price: 34890,
        title: 'Film Camera',
      ),
      ProductItem(
        imageUrl: 'https://i.imgur.com/VAyYluz.jpg',
        price: 3300,
        title: 'Wireless Keyboard',
      ),
      ProductItem(
        imageUrl: 'https://i.imgur.com/Pioz7qm.jpg',
        price: 450,
        title: 'TV Remote',
      ),
    ];
    List<String> imgList = [
      "assets/home/1.png",
      "assets/home/2.png",
      "assets/home/3.png",
      "assets/home/4.png",
    ];
    CarouselSliderController con = CarouselSliderController();
    final SplashController currentIndex = Get.put(SplashController());
    return SafeArea(
      child: SingleChildScrollView(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: customAppBar(
                isHome: true,
                title: "Eco Cycle",
                rank: '12',
                points: '40',
                scaffoldKey: widget.scaffoldKey,
                prf: CircleAvatar(
                    backgroundColor:
                        AppColors.lightGreen.withValues(alpha: 0.5),
                    radius: 28,
                    child: const Icon(
                      Icons.person,
                      color: Colors.green,
                      size: 24,
                    )),
                context: context,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Entry.all(
              delay: const Duration(milliseconds: 20),
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustomText(
                    textName: "${getGreeting()},",
                    fontWeight: FontWeight.w700,
                    textColor: const Color(0xff232323),
                    maxLines: 10,
                    textAlign: TextAlign.right,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Entry.all(
              delay: const Duration(milliseconds: 20),
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustomText(
                    textName: widget.user?.username.capitalizeFirstOfEach ??
                        "Not Fetched",
                    fontWeight: FontWeight.w700,
                    textColor: const Color(0xff232323),
                    maxLines: 10,
                    textAlign: TextAlign.right,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            /// Top Image carousel
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 0),
                    blurRadius: 24,
                    color: Colors.black.withValues(alpha: 0.1))
              ]),
              child: Entry.all(
                delay: const Duration(milliseconds: 20),
                child: AppCarouselSlider(
                  con: con,
                  imgList: imgList,
                  currentIndex: currentIndex,
                  height: MediaQuery.of(context).size.height * 0.21,
                ),
              ),
            ),
            Entry.all(
              delay: const Duration(milliseconds: 20),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                height: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
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
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) => Stack(
                        alignment: Alignment.center,
                        children: [
                          /// Progress indicator
                          CustomPaint(
                            size: Size(
                              MediaQuery.of(context).size.width * 0.2,
                              MediaQuery.of(context).size.width * 0.2,
                            ),
                            painter: CircularProgressPainter(
                              progress: _progressAnimation.value,
                              color: AppColors.green,
                              strokeWidth: 9,
                            ),
                          ),

                          /// Percentage text
                          Text(
                            '${_percentageAnimation.value}%',
                            style: TextStyle(
                              color: AppColors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.2,
                          //   height: MediaQuery.of(context).size.width * 0.2,
                          //   child: TweenAnimationBuilder<double>(
                          //     tween: Tween<double>(
                          //         begin: 0.0, end: 0.85), // 85% = 0.85
                          //     duration: const Duration(
                          //         seconds: 1), // Animation duration
                          //     builder: (context, value, child) {
                          //       return CircularProgressIndicator(
                          //         value: value,
                          //         valueColor: AlwaysStoppedAnimation<Color>(
                          //             AppColors.green),
                          //       );
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Entry.all(
              delay: Duration(milliseconds: 20),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: CustomText(
                  textName: "Your Listed Products",
                  fontWeight: FontWeight.w700,
                  textColor: Color(0xff232323),
                  maxLines: 10,
                  textAlign: TextAlign.right,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),

            /// Product Grid
            StaggeredGridView.countBuilder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _products.length,
                shrinkWrap: true,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                addRepaintBoundaries: true,
                physics: const BouncingScrollPhysics(),
                controller: controller,
                staggeredTileBuilder: (index) =>
                    const StaggeredTile.count(2, 3),
                crossAxisCount: 4,
                itemBuilder: (context, index) {
                  return Entry.all(
                    delay: const Duration(milliseconds: 20),
                    child: marketplaceView()
                        .card(product: _products[index], context: context),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate center of the canvas
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Create paint for arc
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw the arc from top center position
    const startAngle = -pi / 2; // Start from top (270 degrees)
    final sweepAngle = 2 * pi * progress; // Draw based on progress

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
