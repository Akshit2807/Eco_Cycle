import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';

class CommunityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// **1. Create a new blog post**
  Future<void> createPost(BuildContext context, PostModel post) async {
    try {
      await _firestore.collection('posts').doc(post.postId).set(post.toMap());
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            margin: EdgeInsets.only(
              bottom: kBottomNavigationBarHeight + 16,
              left: 16,
              right: 16,
            ),
            behavior: SnackBarBehavior.floating,
            content: Text("✅ Post created successfully!")),
      );
      print("Post created: ${post.postId}");
    } catch (e) {
      print("Error creating post: $e");
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            margin: EdgeInsets.only(
              bottom: kBottomNavigationBarHeight + 16,
              left: 16,
              right: 16,
            ),
            behavior: SnackBarBehavior.floating,
            content: Text("❌ Failed to create post!")),
      );
    }
  }

  /// **2. Fetch all posts (ordered by latest)**
  Stream<List<PostModel>> fetchPosts() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      print("Fetched ${snapshot.docs.length} posts.");
      return snapshot.docs.map((doc) => PostModel.fromMap(doc.data())).toList();
    });
  }

  /// **3. Like/Unlike a Post**
  Future<void> likePost(
      BuildContext context, String postId, String userId, bool isLiked) async {
    try {
      DocumentReference postRef = _firestore.collection('posts').doc(postId);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(postRef);
        if (snapshot.exists) {
          int currentLikes = snapshot['likes'] ?? 0;
          transaction.update(postRef,
              {'likes': isLiked ? currentLikes + 1 : currentLikes - 1});
        }
      });
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(isLiked ? "❤️ Liked post!" : "💔 Unliked post!")),
      );
      print("Post $postId ${isLiked ? 'liked' : 'unliked'} by $userId");
    } catch (e) {
      print("Error liking post: $e");
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to like post!")),
      );
    }
  }

  /// **4. Add a comment to a post**
  Future<void> addComment(BuildContext context, String postId,
      Map<String, dynamic> commentData) async {
    try {
      DocumentReference postRef = _firestore.collection('posts').doc(postId);
      CollectionReference commentsRef = postRef.collection('comments');

      await commentsRef.add(commentData);
      await postRef.update({'commentsCount': FieldValue.increment(1)});
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("💬 Comment added!")),
      );
      print("Comment added to post $postId: ${commentData['content']}");
    } catch (e) {
      print("Error adding comment: $e");
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to add comment!")),
      );
    }
  }

  /// **5. Fetch comments for a post**
  Stream<List<Map<String, dynamic>>> fetchComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      print("Fetched ${snapshot.docs.length} comments for post $postId.");
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  /// **6. Bookmark/Unbookmark a post**
  Future<void> toggleBookmark(BuildContext context, String postId,
      String userId, bool isBookmarked) async {
    try {
      DocumentReference postRef = _firestore.collection('posts').doc(postId);
      await postRef.update({
        'bookmarks': isBookmarked
            ? FieldValue.arrayUnion([userId])
            : FieldValue.arrayRemove([userId])
      });
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                isBookmarked ? "🔖 Post bookmarked!" : "📌 Bookmark removed!")),
      );
      print(
          "Post $postId ${isBookmarked ? 'bookmarked' : 'unbookmarked'} by $userId");
    } catch (e) {
      print("Error updating bookmark: $e");
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to update bookmark!")),
      );
    }
  }

  /// **7. Report a post as spam**
  Future<void> reportPost(
      BuildContext context, String postId, String userId) async {
    try {
      DocumentReference postRef = _firestore.collection('posts').doc(postId);
      await postRef.update({
        'reports': FieldValue.arrayUnion([userId])
      });
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Post reported as spam!")),
      );
      print("Post $postId reported by $userId");
    } catch (e) {
      print("Error reporting post: $e");
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to report post!")),
      );
    }
  }
}
