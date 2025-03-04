import 'package:e_waste/core/utils/custom_app_bar.dart';
import 'package:e_waste/presentation/dashboard/Blog_Section/blog_post_list.dart';
import 'package:e_waste/viewmodels/community_viewmodel.dart';
import 'package:e_waste/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: Colors.white30,
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
                prf: const Image(image: AssetImage("assets/prf.png")),
                context: context,
              ),
            ),
            const SizedBox(height: 12),

            /// Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: buildSearchBar(padding: 10),
            ),
            const SizedBox(height: 24),

            /// Blogs List
            const Expanded(
              child: BlogPostListWidget(),
            ),
          ],
        ),
      ),

      /// Floating Action Button for creating a new post.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Get.offAllNamed(RouteNavigation.createPostScreenRoute);
          Navigator.pushNamed(context, '/createPost');
        },
        tooltip: 'Create a Post',
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ), // Pencil icon.
      ),
    );
  }
}
