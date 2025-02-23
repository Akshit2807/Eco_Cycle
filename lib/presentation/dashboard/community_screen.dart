import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_icons.dart';
import 'package:e_waste/core/utils/custom_app_bar.dart';
import 'package:e_waste/viewmodels/community_viewmodel.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:e_waste/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          /// App Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
            child: customAppBar(
                isHome: false,
                title: "Blogs",
                rank: '12',
                points: '40',
                prf: const Image(image: AssetImage("assets/prf.png"))),
          ),
          const SizedBox(
            height: 12,
          ),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Side Bar
                Container(
                  width: 60,
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16))),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      communityViews()
                          .buildSidebarIcon(AppIcons.filter, isActive: true),
                      communityViews().buildSidebarIcon(AppIcons.cpu),
                      communityViews().buildSidebarIcon(AppIcons.tree),
                      communityViews().buildSidebarIcon(AppIcons.building),
                      communityViews().buildSidebarIcon(AppIcons.devices),
                      communityViews().buildSidebarIcon(AppIcons.microscope),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                /// Main Content
                Expanded(
                  child: Column(
                    children: [
                      /// Search Bar
                      buildSearchBar(),
                      const SizedBox(
                        height: 24,
                      ),

                      /// Blogs List
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                              right: 24, left: 24, top: 0),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return communityViews().buildBlogCard();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
