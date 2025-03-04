import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_icons.dart';
import 'package:e_waste/viewmodels/point_history_viewmodel.dart';
import 'package:e_waste/viewmodels/rewards_viewmodel.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:e_waste/widgets/percentage_sized_box.dart';
import 'package:e_waste/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class PointHistoryScreen extends StatelessWidget {
  const PointHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<PointHistory> points = [
      PointHistory(points: 10, date: "10 Jan 2023"),
      PointHistory(points: 10, date: "10 Jan 2023"),
      PointHistory(points: 10, date: "10 Jan 2023"),
      PointHistory(points: 10, date: "10 Jan 2023"),
      PointHistory(points: 10, date: "10 Jan 2023"),
      PointHistory(points: 10, date: "10 Jan 2023"),
      PointHistory(points: 10, date: "10 Jan 2023"),
      PointHistory(points: 10, date: "10 Jan 2023"),
      PointHistory(points: 10, date: "10 Jan 2023"),
      PointHistory(points: 10, date: "10 Jan 2023"),
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.topRight,
                      image: AssetImage("assets/point_history_bg.png"))),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Back Button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      margin: const EdgeInsets.only(top: 24, left: 12),
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 28,
                                color: Colors.black.withValues(alpha: 0.2))
                          ],
                          borderRadius: BorderRadius.circular(360),
                          color: AppColors.white),
                      child: ImageIcon(
                        AssetImage(AppIcons.back),
                        color: AppColors.green,
                      )),
                ),
                PercentSizedBox.height(0.06),

                /// Title
                const Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: CustomText(
                      textName: "Point History",
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                PercentSizedBox.height(0.02),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 24, right: 24),
                    padding:
                        const EdgeInsets.only(top: 16, right: 16, left: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildSearchBar(padding: 0),
                          PercentSizedBox.height(0.015),

                          /// Today
                          const CustomText(
                            textName: "Today",
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              itemCount: 4,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 16),
                              itemBuilder: (BuildContext context, int index) {
                                return rewardView().buildPointHistoryTile(
                                    points: points.elementAt(index).points,
                                    date: points.elementAt(index).date);
                              }),
                          PercentSizedBox.height(0.015),
                          const CustomText(
                            textName: "Past 7 days",
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),

                          /// Past 7 Days
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              itemCount: 4,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 16),
                              itemBuilder: (BuildContext context, int index) {
                                return rewardView().buildPointHistoryTile(
                                    points: points.elementAt(index).points,
                                    date: points.elementAt(index).date);
                              }),
                          PercentSizedBox.height(0.015),

                          /// Past 1 month
                          const CustomText(
                            textName: "Past 1 month",
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              itemCount: 4,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 16),
                              itemBuilder: (BuildContext context, int index) {
                                return rewardView().buildPointHistoryTile(
                                    points: points.elementAt(index).points,
                                    date: points.elementAt(index).date);
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                PercentSizedBox.height(0.02),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
