import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_waste/data/repositories/community_repository.dart';
import 'package:e_waste/widgets/comment_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A screen to display and add comments for a specific post.
class CommentsScreen extends StatefulWidget {
  /// The ID of the post for which comments are being displayed.
  final String postId;

  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  // Instance of CommunityRepository to access Firestore functions.
  final CommunityRepository _repository = CommunityRepository();

  // Controller for the comment input field.
  final TextEditingController _commentController = TextEditingController();

  /// Submits a new comment to Firestore.
  Future<void> _submitComment() async {
    // Retrieve the current user from FirebaseAuth.
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in to comment.")),
      );
      return;
    }

    // Get user details from FirebaseAuth.
    String currentUserId = user.uid;
    String currentUsername = user.displayName ?? 'Anonymous';
    String currentUserProfilePic = user.photoURL ??
        'https://imgs.search.brave.com/prpbPTMAYp2IA5lapKLeVJlEtZBzWn_GGlcchFotrkU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJzLmNvbS9p/bWFnZXMvZmVhdHVy/ZWQvbWluZWNyYWZ0/LW1lbWUtcGljdHVy/ZXMteW14d2U2dHk5/N2h2b2JrMC5qcGc';

    // Trim any extra whitespace.
    String commentText = _commentController.text.trim();
    if (commentText.isEmpty) {
      // Inform the user that an empty comment is not allowed.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comment cannot be empty.")),
      );
      return;
    }

    // Prepare the comment data.
    Map<String, dynamic> commentData = {
      'userId': currentUserId,
      'username': currentUsername,
      'userProfilePic': currentUserProfilePic,
      'comment': commentText,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      // Attempt to add the comment using the repository.
      await _repository.addComment(context, widget.postId, commentData);
      // Clear the input field upon success.
      _commentController.clear();
      print("Comment submitted: $commentText");
    } catch (e) {
      // Print error and notify the user.
      print("Error submitting comment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit comment.")),
      );
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed.
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Building CommentsScreen for postId: ${widget.postId}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
      ),
      body: Column(
        children: [
          // Display the list of comments.
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _repository.fetchComments(widget.postId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print("Error fetching comments: ${snapshot.error}");
                  return const Center(child: Text("Error loading comments."));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                List<Map<String, dynamic>> comments = snapshot.data!;
                print("Fetched ${comments.length} comments.");
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    // Each comment is rendered using the CommentCard widget.
                    Map<String, dynamic> comment = comments[index];
                    return CommentCard(comment: comment);
                  },
                );
              },
            ),
          ),
          // Divider and input area for adding a new comment.
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                // Input field for comment text.
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Add a comment...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                // Send button to submit the comment.
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _submitComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
