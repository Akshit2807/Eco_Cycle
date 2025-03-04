import 'dart:developer';
import 'package:e_waste/data/models/base_64_model.dart';
import 'package:e_waste/data/secure_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../router/app_router.dart';

TokenService tokenService = TokenService();

class CameraService {
  File? _image;
  String? _base64String;
  bool tapped = false;

  Future<String?> imgToBase64() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Read image bytes
      Uint8List imageBytes = await imageFile.readAsBytes();

      // Decode image for processing
      img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) return null;

      // Resize Image (Reduce size for fast response)
      img.Image resizedImage =
          img.copyResize(originalImage, width: 600); // Resize to 600px width

      // Compress Image to JPEG (Reduce file size)
      Uint8List compressedBytes =
          Uint8List.fromList(img.encodeJpg(resizedImage, quality: 70));

      // Convert to Base64
      String base64String = base64Encode(compressedBytes);

      _image = imageFile;
      _base64String = base64String;
      SecureStorageService()
          .saveData(value: pickedFile.path, key: "clickedImg");
      return _base64String;
    }
    return null;
  }

  static Future<Base64> getCategory() async {
    String? token = await tokenService.getToken();
    String? base64 = await CameraService().imgToBase64();
    log('$token');

    const url =
        'https://geminiapiwrap.onrender.com/ai/categorize_ewaste_base64';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    Map<String, dynamic> body = {"image_base64": base64};

    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('Response Code : ${response.statusCode}');
      final String responseBody = response.body;
      SecureStorageService()
          .saveData(value: responseBody, key: "Base64Response");
      final Base64 obj = base64FromJson(responseBody);
      return obj;
    } else {
      Get.toNamed(
        RouteNavigation.navScreenRoute,
      );
      debugPrint('Response Code : ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }
}
