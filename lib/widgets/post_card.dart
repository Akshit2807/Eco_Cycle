import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Header Row**: Profile picture, username + timestamp, overflow menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Profile Picture
                CircleAvatar(
                  backgroundImage: NetworkImage(post.userProfilePic),
                  radius: 20,
                ),
                const SizedBox(width: 10),

                /// Username & Timestamp
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Row for (username) and (3-dot menu)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              post.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          /// e.g., "2h"
                          Text(
                            postedTime,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),

                          /// **3-dot (overflow) menu** for "Report" etc.
                          PopupMenuButton<String>(
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
                                  child: Center(child: Text('Report')),
                                ),
                              ];
                            },
                            icon: const Icon(Icons.more_vert, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// Spacing before the post text
            const SizedBox(height: 8),

            /// **Post Text Content**
            Text(
              post.content,
              style: const TextStyle(fontSize: 14),
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
                      Icon(Icons.mode_comment_outlined,
                          size: 18, color: Colors.grey[700]),
                      const SizedBox(width: 4),
                      Text(
                        "${post.commentsCount}",
                        style: TextStyle(color: Colors.grey[700]),
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
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isLiked ? Colors.red : Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${post.likes.length}",
                        style: TextStyle(color: Colors.grey[700]),
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
                  child: Icon(Icons.share_outlined,
                      size: 18, color: Colors.grey[700]),
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
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        size: 18,
                        color: isBookmarked ? Colors.orange : Colors.grey[700],
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
