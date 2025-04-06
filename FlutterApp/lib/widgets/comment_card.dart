import 'package:cloud_firestore/cloud_firestore.dart'; // For Timestamp
import 'package:flutter/material.dart';

/// A widget that displays an individual comment.
///
/// Expects a [Map<String, dynamic>] with the following keys:
/// - 'username': (String) The commenter's name.
/// - 'userProfilePic': (String) URL of the commenter's profile image.
/// - 'comment': (String) The comment text.
/// - 'timestamp': (Timestamp) When the comment was posted.
class CommentCard extends StatelessWidget {
  final Map<String, dynamic> comment;

  const CommentCard({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve values from the comment map with defaults.
    final String username = comment['username'] ?? 'Anonymous';
    final String userProfilePic =
        comment['userProfilePic'] ?? 'https://example.com/default.png';
    final String commentText = comment['comment'] ?? '';

    // Format the timestamp if available.
    String formattedTime = '';
    if (comment['timestamp'] != null && comment['timestamp'] is Timestamp) {
      DateTime dateTime = (comment['timestamp'] as Timestamp).toDate();
      formattedTime =
          '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userProfilePic),
      ),
      title: Text(
        username,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(commentText),
      trailing: Text(
        formattedTime,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }
}
