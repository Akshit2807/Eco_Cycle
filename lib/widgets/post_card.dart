import 'package:e_waste/core/utils/extensions.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../core/utils/app_colors.dart';
import '../data/models/post_model.dart';
import '../viewmodels/community_viewmodel.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final String currentUserId;

  const PostCard({
    Key? key,
    required this.post,
    required this.currentUserId,
  }) : super(key: key);

  /// Formats the post's timestamp into a short "time ago" string (e.g., "2h", "3d").
  /// If you don't want to use the `timeago` package, you can manually compute hours/days.
  String _formatTimestamp(DateTime postTime) {
    final now = DateTime.now();
    final difference = now.difference(postTime);
    // For example, we can do a simple approach:
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
    // Or if you have the timeago package:
    // return timeago.format(postTime, locale: 'en_short');
  }

  @override
  Widget build(BuildContext context) {
    final communityVM = Provider.of<CommunityViewModel>(context, listen: false);

    // Check if the current user has liked/bookmarked this post.
    bool isLiked = post.likes.contains(currentUserId);
    bool isBookmarked = post.bookmarks.contains(currentUserId);

    // Format the timestamp (e.g., "2h ago").
    final postedTime = _formatTimestamp(post.timestamp);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Header Row**: Profile picture, username + timestamp, overflow menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Profile Picture
                CircleAvatar(
                  backgroundImage: NetworkImage(post.userProfilePic),
                  radius: 20,
                ),
                const SizedBox(width: 10),

                /// Username & Timestamp
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustomText(
                    textName: post.username.capitalizeFirstOfEach,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),

                /// e.g., "2h"
                CustomText(
                  textName: postedTime,
                  textColor: AppColors.placeHolder,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                const Spacer(),

                /// **3-dot (overflow) menu** for "Report" etc.
                PopupMenuButton<String>(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  onSelected: (value) {
                    if (value == 'report') {
                      communityVM.reportPost(
                        context,
                        post.postId,
                        currentUserId,
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'report',
                        child: Center(
                            child: CustomText(
                          textName: 'Report',
                          fontWeight: FontWeight.w400,
                        )),
                      ),
                    ];
                  },
                  icon: const Icon(Icons.more_vert, size: 20),
                ),
              ],
            ),

            /// Spacing before the post text
            const SizedBox(height: 8),

            /// **Post Text Content**
            CustomText(
              textName: post.content,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),

            /// If there's an image, display it below the text.
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            /// Spacing before the action row
            const SizedBox(height: 8),

            /// **Action Row**: Comment, Like, Share, Bookmark
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Comment button + count
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/comments',
                        arguments: post.postId);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.message_text,
                        size: 18,
                        color: AppColors.placeHolder,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${post.commentsCount}",
                        style: TextStyle(
                          color: AppColors.placeHolder,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Like button + count
                InkWell(
                  onTap: () => communityVM.toggleLike(
                    context,
                    post.postId,
                    currentUserId,
                    !isLiked,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Iconsax.heart5 : Iconsax.heart,
                        size: 18,
                        color: isLiked ? Colors.red : AppColors.placeHolder,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${post.likes.length}",
                        style: TextStyle(
                          color: AppColors.placeHolder,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Share button
                InkWell(
                  onTap: () {
                    final String shareText =
                        "${post.content}\nRead more: app.com/post/${post.postId}";
                    // Implement your sharing logic here
                    print("Sharing: $shareText");
                  },
                  child: Icon(
                    Iconsax.export_1,
                    size: 18,
                    color: AppColors.placeHolder,
                  ),
                ),

                /// Bookmark button + optional count
                InkWell(
                  onTap: () => communityVM.toggleBookmark(
                    context,
                    post.postId,
                    currentUserId,
                    !isBookmarked,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isBookmarked
                            ? Iconsax.archive_tick
                            : Iconsax.archive_add,
                        size: 18,
                        color: isBookmarked
                            ? Colors.orange
                            : AppColors.placeHolder,
                      ),
                      const SizedBox(width: 4),
                      // If you store a bookmark count, you can display it here.
                      // e.g., Text("${post.bookmarks.length}")
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
