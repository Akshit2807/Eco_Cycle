import 'dart:convert';
import 'dart:developer';
import 'package:e_waste/core/router/app_router.dart';
import 'package:e_waste/core/services/local_storage_service/secure_storage.dart';
import 'package:e_waste/data/models/base_64_model.dart';
import 'package:e_waste/data/models/decision_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

TokenService tokenService = TokenService();

class DecideService {
  static Future<Decision> getGuide(String qns, BuildContext context) async {
    String? token = await tokenService.getToken();
    log('$token');

    const url = 'https://geminiapiwrap.onrender.com/ai/decide';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    log(qns);
    String? jsonString = await SecureStorageService().getData("Base64Response");
    if (jsonString == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Something Went Wrong. Try Again"),
            backgroundColor: Colors.red),
      );
      Get.toNamed(
        RouteNavigation.navScreenRoute,
      );
      throw Exception("Base64Response is missing");
    }
    final Base64 obj = base64FromJson(jsonString);
    Map<String, dynamic> body = {
      "title": obj.title,
      "initial_prod_description": obj.desc,
      "qnas": qns
    };

    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('Response Code : ${response.statusCode}');
      final String responseBody = response.body;
      SecureStorageService().saveData(value: responseBody, key: "DecideAPI");
      SecureStorageService().saveData(value: responseBody, key: "DecideAPI");
      Decision decision = Decision.fromRawJson(responseBody);
      if (decision.decision == "IGN" || decision.guide.initials == "IGN") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Invalid Answers. Try Again"),
              backgroundColor: Colors.red),
        );
        Get.offNamed(RouteNavigation.quetionsScreenRoute, arguments: {
          'title': obj.title,
        });
        debugPrint('Response Code : ${response.statusCode}');
        throw Exception('Invalid Input');
      }
      return decision;
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
