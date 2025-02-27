import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:e_waste/data/secure_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64String = base64Encode(imageBytes);
      _image = imageFile;
      _base64String = base64String;
      return _base64String;
    }
    return null;
  }

  static Future<String> getCategory({required String base64Image}) async {
    String? token = await tokenService.getToken();
    log('$token');

    const url =
        'https://geminiapiwrap.onrender.com/ai/categorize_ewaste_base64';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    Map<String, dynamic> body = {"image_base64": base64Image};

    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('Response Code : ${response.statusCode}');

      final String responseBody = response.body;
      return responseBody;
    } else {
      debugPrint('Response Code : ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }
}
