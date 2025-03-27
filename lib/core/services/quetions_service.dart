import 'dart:convert';
import 'dart:developer';
import 'package:e_waste/core/router/app_router.dart';
import 'package:e_waste/core/services/local_storage_service/secure_storage.dart';
import 'package:e_waste/data/models/quetions_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

TokenService tokenService = TokenService();

class QuestionsService {
  static Future<Quetions> getQuetions(
      String title, BuildContext context) async {
    String? token = await tokenService.getToken();
    log('$token');

    const url = 'https://geminiapiwrap.onrender.com/ai/get_questions';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    Map<String, dynamic> body = {"title": title};

    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('Response Code : ${response.statusCode}');
      final String responseBody = response.body;
      SecureStorageService()
          .saveData(value: responseBody, key: "QuestionsFromAI");
      final Quetions obj = quetionsFromJson(responseBody);
      if (obj.questions.elementAt(0) == "IGN") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Invalid Input. Try Again"),
              backgroundColor: Colors.red),
        );
        Get.toNamed(
          RouteNavigation.navScreenRoute,
        );
        debugPrint('Response Code : ${response.statusCode}');
        throw Exception('Invalid Input');
      }
      return obj;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Something Went Wrong. Try Again"),
            backgroundColor: Colors.red),
      );
      Get.toNamed(
        RouteNavigation.navScreenRoute,
      );
      debugPrint('Response Code : ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }
}
