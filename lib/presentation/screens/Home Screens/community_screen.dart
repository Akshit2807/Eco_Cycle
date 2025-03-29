import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/presentation/components/custom_app_bar.dart';
import 'package:e_waste/viewmodels/community_viewmodel.dart';
import 'package:e_waste/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Blog_Section/blog_post_list.dart';

class CommunityScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CommunityScreen({super.key, required this.scaffoldKey});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CommunityViewModel>(context, listen: false).fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F1F1),
      // SafeArea ensures content is visible in various devices.
      body: SafeArea(
        child: Column(
          children: [
            /// App Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
              child: customAppBar(
                isHome: false,
                title: "Blogs",
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
            const SizedBox(height: 12),

            /// Search Bar
            buildSearchBar(padding: 24),
            const SizedBox(height: 24),

            /// Blogs List
            const Expanded(
              child: BlogPostListWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
