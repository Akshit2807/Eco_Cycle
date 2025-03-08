import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_icons.dart';
import 'package:e_waste/viewmodels/leaderboard_viewmodel.dart';
import 'package:e_waste/widgets/curver_container.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int myItemIndex = 0;
    List<RankItem> ranks = [
      RankItem(
          imageUrl: "assets/prf.png", points: 120, rank: 1, name: "Sarthak"),
      RankItem(
          imageUrl: "assets/prf.png", points: 110, rank: 2, name: "Kautuk"),
      RankItem(imageUrl: "assets/prf.png", points: 100, rank: 3, name: "Menil"),
      RankItem(imageUrl: "assets/prf.png", points: 90, rank: 4, name: "Joy"),
      RankItem(
          imageUrl: "assets/prf.png", points: 80, rank: 5, name: "Animesh"),
      RankItem(imageUrl: "assets/prf.png", points: 70, rank: 6, name: "Atul"),
      RankItem(imageUrl: "assets/prf.png", points: 60, rank: 7, name: "Atul"),
      RankItem(imageUrl: "assets/prf.png", points: 50, rank: 8, name: "Atul"),
      RankItem(
          imageUrl: "assets/prf.png", points: 40, rank: 9, name: "Sarthak"),
      RankItem(
          imageUrl: "assets/prf.png", points: 35, rank: 10, name: "Kautuk"),
      RankItem(imageUrl: "assets/prf.png", points: 30, rank: 11, name: "Menil"),
      RankItem(imageUrl: "assets/prf.png", points: 25, rank: 12, name: "Joy"),
      RankItem(
          imageUrl: "assets/prf.png", points: 20, rank: 13, name: "Animesh"),
      RankItem(imageUrl: "assets/prf.png", points: 15, rank: 14, name: "Atul"),
      RankItem(imageUrl: "assets/prf.png", points: 10, rank: 15, name: "Atul"),
      RankItem(imageUrl: "assets/prf.png", points: 5, rank: 16, name: "Atul"),
    ];
    return SafeArea(
      child: Scaffold(
        bottomSheet: BottomSheet(
          backgroundColor: const Color(0xffFFC862),
          builder: (BuildContext context) => ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColors.lightGreen),
                  child: CustomText(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      textName:
                          "#${ranks.elementAt(myItemIndex).rank.toString()}"),
                ),
                const SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  radius: 20,
                  child: Image.asset(ranks.elementAt(myItemIndex).imageUrl),
                )
              ],
            ),
            title: CustomText(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                maxLines: 1,
                softWrap: true,
                textOverflow: TextOverflow.ellipsis,
                textName: ranks.elementAt(myItemIndex).name),
            trailing: CustomText(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                textName: ranks.elementAt(myItemIndex).points.toString()),
          ),
          onClosing: () {},
        ),
        backgroundColor: const Color(0xffFFF6CC),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      margin: const EdgeInsets.only(top: 12, left: 12),
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360),
                          color: AppColors.white),
                      child: ImageIcon(
                        AssetImage(AppIcons.back),
                        color: AppColors.green,
                      )),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 12, left: 12),
                  child: CustomText(
                    textName: "Leaderboard",
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 240,
                        width: 109,
                        padding: const EdgeInsets.only(top: 8),
                        margin: const EdgeInsets.only(top: 52),
                        decoration: BoxDecoration(
                            color: const Color(0xffFFE875),
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.green,
                              child: Image.asset(
                                ranks.elementAt(2).imageUrl,
                                width: 44,
                                height: 44,
                              ),
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              margin: const EdgeInsets.only(top: 6, bottom: 6),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.circular(360)),
                              child: CustomText(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  textColor: Colors.white,
                                  textName: ranks.elementAt(2).rank.toString()),
                            ),
                            CustomText(
                              textName: ranks.elementAt(2).name,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/medal.png"),
                                const SizedBox(
                                  width: 4,
                                ),
                                CustomText(
                                    textName:
                                        ranks.elementAt(2).points.toString())
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 240,
                        width: 109,
                        padding: const EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                            color: const Color(0xffFF7577),
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.yellow,
                              child: Image.asset(
                                ranks.elementAt(0).imageUrl,
                                width: 44,
                                height: 44,
                              ),
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              margin:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColors.yellow,
                                  borderRadius: BorderRadius.circular(360)),
                              child: CustomText(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  textColor: Colors.white,
                                  textName: ranks.elementAt(0).rank.toString()),
                            ),
                            CustomText(
                              textName: ranks.elementAt(0).name,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/medal.png"),
                                const SizedBox(
                                  width: 4,
                                ),
                                CustomText(
                                    textName:
                                        ranks.elementAt(0).points.toString())
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 28),
                        padding: const EdgeInsets.only(top: 12),
                        height: 240,
                        width: 109,
                        decoration: BoxDecoration(
                            color: const Color(0xffFFB175),
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.green,
                              child: Image.asset(
                                ranks.elementAt(1).imageUrl,
                                width: 44,
                                height: 44,
                              ),
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              margin: const EdgeInsets.only(top: 8, bottom: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.circular(360)),
                              child: CustomText(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  textColor: Colors.white,
                                  textName: ranks.elementAt(1).rank.toString()),
                            ),
                            CustomText(
                              textName: ranks.elementAt(1).name,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/medal.png"),
                                const SizedBox(
                                  width: 4,
                                ),
                                CustomText(
                                    textName:
                                        ranks.elementAt(1).points.toString())
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 190.0),
                    child: ConcaveContainer(
                      height: double.infinity, // Ensures full height
                      backgroundColor: Colors.white,
                      borderColor: Colors.black,
                      // padding: const EdgeInsets.only(top: 80.0),
                      child: ListView.builder(
                          itemCount: ranks.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 80),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: ListTile(
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: AppColors.lightGreen),
                                      child: CustomText(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          textName:
                                              "#${ranks.elementAt(index).rank.toString()}"),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    CircleAvatar(
                                      radius: 20,
                                      child: Image.asset(
                                          ranks.elementAt(index).imageUrl),
                                    )
                                  ],
                                ),
                                title: CustomText(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    maxLines: 1,
                                    softWrap: true,
                                    textOverflow: TextOverflow.ellipsis,
                                    textName: ranks.elementAt(index).name),
                                trailing: CustomText(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textName: ranks
                                        .elementAt(index)
                                        .points
                                        .toString()),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
