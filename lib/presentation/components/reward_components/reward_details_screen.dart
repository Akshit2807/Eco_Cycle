import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_icons.dart';
import 'package:e_waste/viewmodels/rewards_viewmodel.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:e_waste/widgets/percentage_sized_box.dart';
import 'package:flutter/material.dart';

class RewardDetailsScreen extends StatelessWidget {
  const RewardDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.topRight,
                    image: AssetImage("assets/reward_history_bg.png"))),
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
              PercentSizedBox.height(0.1),

              /// Title
              const Padding(
                padding: EdgeInsets.only(left: 24),
                child: CustomText(
                    textName: "Rewards",
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
              PercentSizedBox.height(0.02),
              Expanded(
                child: ListView.builder(
                    itemCount: 15,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 72,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 24),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.lightGreen, width: 2)),
                        child: rewardView().buildRewardTile(bottomPadding: 0),
                      );
                    }),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
