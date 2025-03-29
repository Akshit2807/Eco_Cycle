import 'package:e_waste/data/models/post_model.dart';
import 'package:e_waste/viewmodels/community_viewmodel.dart';
import 'package:e_waste/widgets/post_card.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A widget that builds a responsive list of blog posts.
/// It listens to the CommunityViewModel for real-time updates.
class BlogPostListWidget extends StatelessWidget {
  const BlogPostListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final communityVM = Provider.of<CommunityViewModel>(context);
    final List<PostModel> posts = communityVM.posts;

    if (communityVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (posts.isEmpty) {
      return const Center(child: Text("No posts available."));
    } else {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          // TODO: Replace "dummyUserId" with the actual current user ID from your authentication service.
          return Entry.all(
            delay: const Duration(milliseconds: 20),
            child: PostCard(
              post: post,
              currentUserId: "dummyUserId",
            ),
          );
        },
      );
    }
  }
}
