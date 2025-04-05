import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/extensions.dart';
import 'package:e_waste/data/models/user_model.dart';
import 'package:e_waste/presentation/components/custom_app_bar.dart';
import 'package:e_waste/viewmodels/point_history_viewmodel.dart';
import 'package:e_waste/viewmodels/rewards_viewmodel.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../core/router/app_router.dart';

class RewardScreen extends StatelessWidget {
  final UserModel? user;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const RewardScreen(
      {super.key, required this.scaffoldKey, required this.user});

  @override
  Widget build(BuildContext context) {
    final List<String> rewardTitles = [
      "Discount on Next Pickup",
      "Eco-Friendly Tote Bag",
      "Plant a Tree in Your Name",
      "Reusable Water Bottle",
      "Amazon Gift Card ₹50",
      "Sustainable T-Shirt",
      "Electricity Bill Discount",
      "Amazon Gift Card ₹100",
      "Smart LED Bulb",
      "Exclusive App Badge",
      "Eco-Warrior Certificate",
    ];

    List<PointHistory> points = [
      PointHistory(points: 29, date: "03 Oct 2025"),
      PointHistory(points: 14, date: "09 May 2025"),
      PointHistory(points: 32, date: "24 Dec 2024"),
      PointHistory(points: 36, date: "27 Nov 2024"),
      PointHistory(points: 18, date: "21 Aug 2024"),
      PointHistory(points: 36, date: "20 May 2024"),
      PointHistory(points: 42, date: "17 May 2024"),
      PointHistory(points: 46, date: "11 Jan 2024"),
      PointHistory(points: 19, date: "26 Mar 2023"),
      PointHistory(points: 15, date: "10 Feb 2023"),
    ];
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            /// App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: customAppBar(
                isHome: false,
                title: "Rewards",
                rank: '12',
                points: '40',
                scaffoldKey: scaffoldKey,
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
              height: 24,
            ),

            /// Your Ranking Card
            Entry.all(
              delay: const Duration(milliseconds: 20),
              child: rewardView().buildYourRank(
                  name: user?.username.capitalizeFirstOfEach ?? "Not Fetched",
                  rank: "#12",
                  points: "40",
                  prf: const AssetImage("assets/person.png"),
                  onTap: () {
                    Get.toNamed(RouteNavigation.leaderboardScreenRoute,
                        arguments: {
                          'user': user?.username.capitalizeFirstOfEach ??
                              "Not Fetched",
                        });
                  }),
            ),
            const SizedBox(height: 32),

            /// Rewards Section
            Entry.all(
              delay: const Duration(milliseconds: 20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          textName: 'Rewards',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(
                                RouteNavigation.rewardHistoryScreenRoute);
                          },
                          child: const CustomText(
                            textName: 'Reward History',
                            textColor: Color(0xff569FFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return rewardView().buildRewardTile(
                            bottomPadding: 12,
                            title: rewardTitles.elementAt(index),
                            context: context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            /// Point History Section
            Entry.all(
              delay: const Duration(milliseconds: 20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          textName: 'Point History',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(
                                RouteNavigation.pointHistoryScreenRoute);
                          },
                          child: const CustomText(
                            textName: 'View More',
                            textColor: Color(0xff569FFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return rewardView().buildPointHistoryTile(
                            points: points.elementAt(index).points,
                            date: points.elementAt(index).date);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
