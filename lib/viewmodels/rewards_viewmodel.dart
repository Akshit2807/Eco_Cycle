import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_icons.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_text.dart';

class rewardView {
  Padding buildYourRank(
      {required String name,
      required String rank,
      required String points,
      required ImageProvider prf,
      required void Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        height: 108,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  textName: "Your Ranking",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.dark,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onTap,
                  child: Row(
                    children: [
                      const CustomText(
                        textName: "View",
                        textColor: Color(0xff569FFF),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Image.asset(
                        AppIcons.leaderboard,
                        height: 27,
                        width: 27,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(children: [
              CircleAvatar(
                  radius: 16,
                  child: Image(
                    image: prf,
                  )),
              const SizedBox(
                width: 6,
              ),
              CustomText(
                textName: name,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                textColor: AppColors.dark,
                textOverflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              const Spacer(),
              Container(
                alignment: Alignment.center,
                height: 23,
                width: 38,
                decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(6)),
                child: CustomText(
                  textName: rank,
                  textColor: AppColors.dark,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Image.asset(AppIcons.medal),
              const SizedBox(
                width: 4,
              ),
              CustomText(
                textName: points,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor: AppColors.dark,
              ),
            ])
          ],
        ),
      ),
    );
  }

  Padding buildRewardTile({required double bottomPadding}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Row(
        children: [
          Image.asset(AppIcons.gift),
          const SizedBox(width: 12),
          const CustomText(
            textName: 'Recycled E-Waste',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.green, width: 1.5),
                  borderRadius: BorderRadius.circular(30)),
              child: CustomText(
                textName: 'Claim',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: AppColors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPointHistoryTile({required String date, required int points}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          CustomText(
            textName: date,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          const Spacer(),
          CustomText(
            textName: points.toString(),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            textColor: AppColors.yellow,
          ),
          const SizedBox(width: 8),
          Image.asset(AppIcons.star)
        ],
      ),
    );
  }
}
