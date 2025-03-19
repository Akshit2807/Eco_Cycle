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
  static Future<Decision> getGuide(String qns) async {
    String? token = await tokenService.getToken();
    log('$token');

    const url = 'https://geminiapiwrap.onrender.com/ai/decide';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    String? jsonString = await SecureStorageService().getData('Base64Response');
    final Base64 obj = base64FromJson(jsonString!);
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
      return decisionFromJson(responseBody);
    } else {
      Get.toNamed(
        RouteNavigation.navScreenRoute,
      );
      debugPrint('Response Code : ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }
}
