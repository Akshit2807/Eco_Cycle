import 'package:audioplayers/audioplayers.dart';
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

  const HomeScreen({
    super.key,
    required this.scaffoldKey,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;

  UserModel? user;
  @override
  void initState() {
    super.initState();
    fetchUserData();
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

  Future<void> fetchUserData() async {
    user = await UserRepository().fetchUserDetails();
    if (user != null) {
      setState(() {
        username = user?.username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    final List<ProductItem> _products = [
      ProductItem(
        imageUrl: 'https://i.imgur.com/vf2NbUQ.png',
        price: 250,
        title: 'Old Mobile Phones',
      ),
      ProductItem(
        imageUrl: 'https://i.imgur.com/dVlbWoc.png',
        price: 800,
        title: 'Electronic Parts',
      ),
      ProductItem(
        imageUrl: 'https://i.imgur.com/V3i9hGV.png',
        price: 600,
        title: 'CRT Monitors',
      ),
      ProductItem(
        imageUrl: 'https://i.imgur.com/EfIgN8f.png',
        price: 1000,
        title: 'AC Unit',
      ),
      ProductItem(
        imageUrl: 'https://i.imgur.com/vf2NbUQ.png',
        price: 250,
        title: 'Old Mobile Phones',
      ),
      ProductItem(
        imageUrl: 'https://i.imgur.com/dVlbWoc.png',
        price: 800,
        title: 'Electronic Parts',
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
                    textName: username!.capitalizeFirstOfEach,
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
                    color: Colors.black.withOpacity(0.1))
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
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.green),
                            strokeWidth: 10,
                            value: 0.85,
                          ),
                        ),
                      ],
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
