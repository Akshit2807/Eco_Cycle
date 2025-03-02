/// **CommunityViewModel**
/// Manages state for posts, likes, comments, and user interactions.

import 'package:flutter/material.dart';

import '../data/models/post_model.dart';
import '../data/repositories/community_repository.dart';

class CommunityViewModel extends ChangeNotifier {
  final CommunityRepository _repository = CommunityRepository();

  List<PostModel> _posts = [];
  bool _isLoading = false;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;

  /// **1. Fetch Posts in Realtime**
  void fetchPosts() {
    _repository.fetchPosts().listen((postList) {
      _posts = postList;
      notifyListeners();
    }, onError: (error) {
      debugPrint("Error fetching posts: $error");
    });
  }

  /// **2. Create a Post**
  Future<void> createPost(BuildContext context, PostModel post) async {
    _isLoading = true;
    notifyListeners();

    await _repository.createPost(context, post);

    _isLoading = false;
    notifyListeners();
  }

  /// **3. Like/Unlike a Post**
  Future<void> toggleLike(
      BuildContext context, String postId, String userId, bool isLiked) async {
    await _repository.likePost(context, postId, userId, isLiked);
    notifyListeners();
  }

  /// **4. Add a Comment**
  Future<void> addComment(BuildContext context, String postId,
      Map<String, dynamic> commentData) async {
    await _repository.addComment(context, postId, commentData);
    notifyListeners();
  }

  /// **5. Bookmark/Unbookmark a Post**
  Future<void> toggleBookmark(BuildContext context, String postId,
      String userId, bool isBookmarked) async {
    await _repository.toggleBookmark(context, postId, userId, isBookmarked);
    notifyListeners();
  }

  /// **6. Report a Post**
  Future<void> reportPost(
      BuildContext context, String postId, String userId) async {
    await _repository.reportPost(context, postId, userId);
    notifyListeners();
  }
}
