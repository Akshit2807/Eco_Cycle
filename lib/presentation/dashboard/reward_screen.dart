import 'package:e_waste/core/utils/app_colors.dart' show AppColors;
import 'package:e_waste/core/utils/app_icons.dart';
import 'package:e_waste/core/utils/custom_app_bar.dart';
import 'package:e_waste/viewmodels/rewards_viewmodel.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          /// App Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: customAppBar(
                isHome: false,
                title: "Rewards",
                rank: '12',
                points: '40',
                prf: const Image(image: AssetImage("assets/prf.png"))),
          ),
          const SizedBox(
            height: 24,
          ),

          /// Your Ranking Card
          rewardView().buildYourRank(
              "Sarthak Patil", "#12", "40", const AssetImage("assets/prf.png")),
          const SizedBox(height: 32),

          /// Rewards Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 32.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
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
                      onPressed: () {},
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
                    return rewardView().buildRewardTile();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          /// Point History Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 32.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
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
                      onPressed: () {},
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
                    return rewardView().buildPointHistoryTile();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
