import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_waste/core/router/app_router.dart';
import 'package:e_waste/core/services/local_storage_service/secure_storage.dart';
import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/data/models/post_model.dart';
import 'package:e_waste/viewmodels/community_viewmodel.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

/// A screen for creating a new blog post.
/// Users can write text, pick an image, and submit the post.
class CreatePostScreen extends StatefulWidget {
  File? passedImage;
  String? passedImagePath;
  CreatePostScreen({super.key, this.passedImage, this.passedImagePath});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // Controller for the post content input field.
  final TextEditingController _contentController = TextEditingController();
  final SecureStorageService secureStorageService = SecureStorageService();

  // Image file selected by the user.
  File? _selectedImage;
  String? _base64Image;

  // Instance of ImagePicker to allow image selection.
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from the gallery and converts it to base64.
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Reduce quality to save storage space
      maxWidth: 800, // Limit dimensions to reduce file size
      maxHeight: 800,
    );

    if (pickedFile != null) {
      // Read the image as bytes and convert to base64
      final bytes = await File(pickedFile.path).readAsBytes();
      String base64Image = base64Encode(bytes);

      setState(() {
        _selectedImage = File(pickedFile.path);
        _base64Image = base64Image;
      });
      print(
          "Image selected and converted to base64 (${base64Image.length} characters)");
    } else {
      print("No image selected.");
    }
  }

  /// Submits the new post with base64 encoded image.
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

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Creating post...")),
    );

    // Generate a unique post ID using Firestore.
    String postId = FirebaseFirestore.instance.collection('posts').doc().id;

    String? userName = FirebaseAuth.instance.currentUser?.displayName;
    print('username in create post : $userName');

    /// Create a new PostModel object with base64 image
    PostModel newPost = PostModel(
      postId: postId,
      authorId: currentUser.uid,
      username: userName ?? "UserNameNull",
      userProfilePic: currentUser.photoURL ??
          "https://imgs.search.brave.com/prpbPTMAYp2IA5lapKLeVJlEtZBzWn_GGlcchFotrkU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJzLmNvbS9p/bWFnZXMvZmVhdHVy/ZWQvbWluZWNyYWZ0/LW1lbWUtcGljdHVy/ZXMteW14d2U2dHk5/N2h2b2JrMC5qcGc",
      content: content,
      imageUrl: null, // No longer using external URL
      base64Image: _base64Image, // Add base64 image data
      likes: const [],
      commentsCount: 0,
      shares: 0,
      bookmarks: const [],
      reports: const [],
      timestamp: DateTime.now(),
    );

    try {
      // Use CommunityViewModel to create the post.
      await Provider.of<CommunityViewModel>(context, listen: false)
          .createPost(context, newPost);

      // Clear the fields after submission.
      _contentController.clear();
      setState(() {
        _selectedImage = null;
        _base64Image = null;
      });

      // Provide feedback.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post created successfully!")),
      );
      Get.offAllNamed(RouteNavigation.homeScreenRoute);
      print("Post created with ID: $postId");
    } catch (e) {
      print("Error creating post: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create post: $e")),
      );
    }
  }

  Future<void> initPassedData() async {
    final bytes = await File(widget.passedImagePath!).readAsBytes();
    String base64Image = base64Encode(bytes);
    setState(() {
      _selectedImage = widget.passedImage;
      _base64Image = base64Image;
    });
  }

  @override
  void initState() {
    widget.passedImage != null ? initPassedData() : null;
    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffF1F1F1),
        title: const CustomText(
          textName: "Create Post",
          fontSize: 20,
        ),
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
                  icon: const Icon(Iconsax.image),
                  label: const CustomText(
                    textName: "Add Image",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _submitPost,
                  icon: const Icon(Iconsax.export_24),
                  label: const CustomText(
                    textName: "Post",
                    fontWeight: FontWeight.w500,
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
