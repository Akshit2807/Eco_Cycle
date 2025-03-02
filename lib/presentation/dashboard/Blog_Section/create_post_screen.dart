import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_waste/core/router/app_router.dart';
import 'package:e_waste/data/models/post_model.dart';
import 'package:e_waste/viewmodels/community_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

/// A screen for creating a new blog post.
/// Users can write text, pick an image, and submit the post.
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // Controller for the post content input field.
  final TextEditingController _contentController = TextEditingController();

  // Image file selected by the user.
  File? _selectedImage;

  // Instance of ImagePicker to allow image selection.
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from the gallery.
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      print("Image selected: ${pickedFile.path}");
    } else {
      print("No image selected.");
    }
  }

  /// Submits the new post.
  /// Uploads the image (if selected) and creates a PostModel.
  Future<void> _submitPost() async {
    // Retrieve the current user from FirebaseAuth.
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("You must be logged in to create a post.")),
      );
      return;
    }

    // Retrieve text content.
    String content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post content cannot be empty.")),
      );
      return;
    }

    // Generate a unique post ID using Firestore.
    String postId = FirebaseFirestore.instance.collection('posts').doc().id;
    String? imageUrl;

    // If an image was selected, upload it to Firebase Storage.
    if (_selectedImage != null) {
      try {
        Reference storageRef =
            FirebaseStorage.instance.ref().child('posts/$postId.jpg');
        UploadTask uploadTask = storageRef.putFile(_selectedImage!);
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
        print("Image uploaded: $imageUrl");
      } catch (e) {
        print("Image upload error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to upload image.")),
        );
        return;
      }
    }

    //TODO: Remove this block after making a separate file for it
    ///Get the user's name from Firestore.
    // String? uid = FirebaseAuth.instance.currentUser?.uid;
    // String? name;
    // DocumentSnapshot userDoc =
    //     await FirebaseFirestore.instance.collection('users').doc(uid).get();
    // name = userDoc['name'];
    // print(name);

    // Create a PostModel instance.
    // Note: In a real-world app, replace dummy values with actual user data.
    PostModel newPost = PostModel(
      postId: postId,
      authorId: currentUser.uid,
      username: "Anonymous",
      //TODO add name like name ?? "Anonymous"
      userProfilePic: currentUser.photoURL ??
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7ZUH9hk_myu6ZPuSpjftGScE0fAnCQHq7ZmWxAqYnJXff5k18X08xv9My2poYpq-Tqsw",
      content: content,
      imageUrl: imageUrl,
      likes: const [],
      // Initially, no likes.
      commentsCount: 0,
      shares: 0,
      bookmarks: const [],
      reports: const [],
      timestamp: DateTime.now(),
    );

    // Use CommunityViewModel to create the post.
    await Provider.of<CommunityViewModel>(context, listen: false)
        .createPost(context, newPost);

    // Clear the fields after submission.
    _contentController.clear();
    setState(() {
      _selectedImage = null;
    });

    // Provide feedback.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post created successfully!")),
    );
    Get.offAllNamed(RouteNavigation.communityScreenRoute);
    print("Post created with ID: $postId");
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text field for post content.
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            // Display the selected image if available.
            _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(_selectedImage!,
                        height: 200, fit: BoxFit.cover),
                  )
                : Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(child: Text("No image selected")),
                  ),
            const SizedBox(height: 16),
            // Row with buttons to pick an image and submit the post.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Add Image"),
                ),
                ElevatedButton.icon(
                  onPressed: _submitPost,
                  icon: const Icon(Icons.send),
                  label: const Text("Post"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
