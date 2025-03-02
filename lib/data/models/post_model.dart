/// **PostModel**
/// Represents a blog post in the community section.
/// Includes fields for user details, post content, engagement metrics, and timestamps.

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  /// Unique identifier for the post.
  final String postId;

  /// User ID of the post creator.
  final String authorId;

  /// Username of the post creator.
  final String username;

  /// URL of the post creator's profile picture.
  final String userProfilePic;

  /// Text content of the post.
  final String content;

  /// Optional URL of an image attached to the post.
  final String? imageUrl;

  /// List of user IDs who have liked the post.
  final List<String> likes;

  /// Count of comments on the post.
  final int commentsCount;

  /// Count of shares of the post.
  final int shares;

  /// List of user IDs who have bookmarked the post.
  final List<String> bookmarks;

  /// List of user IDs who have reported the post as spam.
  final List<String> reports;

  /// Timestamp when the post was created.
  final DateTime timestamp;

  /// **Constructor**
  PostModel({
    required this.postId,
    required this.authorId,
    required this.username,
    required this.userProfilePic,
    required this.content,
    this.imageUrl,
    this.likes = const [],
    this.commentsCount = 0,
    this.shares = 0,
    this.bookmarks = const [],
    this.reports = const [],
    required this.timestamp,
  });

  /// **Converts a Firestore document (Map) into a PostModel object.**
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] ?? '',
      authorId: map['authorId'] ?? '',
      username: map['username'] ?? '',
      userProfilePic: map['userProfilePic'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'] as String?,
      likes: List<String>.from(map['likes'] ?? []),
      commentsCount: map['commentsCount'] ?? 0,
      shares: map['shares'] ?? 0,
      bookmarks: List<String>.from(map['bookmarks'] ?? []),
      reports: List<String>.from(map['reports'] ?? []),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  /// **Converts a PostModel object to a Map for storing in Firestore.**
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'authorId': authorId,
      'username': username,
      'userProfilePic': userProfilePic,
      'content': content,
      'imageUrl': imageUrl,
      'likes': likes,
      'commentsCount': commentsCount,
      'shares': shares,
      'bookmarks': bookmarks,
      'reports': reports,
      'timestamp': timestamp,
    };
  }

  /// **Converts the PostModel to JSON format.**
  String toJson() => json.encode(toMap());

  /// **Creates a PostModel from JSON format.**
  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));
}
