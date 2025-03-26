import 'package:e_waste/core/services/local_storage_service/secure_storage.dart';
import 'package:e_waste/data/models/base_64_model.dart';
import 'package:flutter/material.dart';

class RecycleResellService {
  static Future<List<dynamic>> getData(
      String title, BuildContext context) async {
    String filePath = (await SecureStorageService().getData("clickedImg"))!;
    String? jsonString = await SecureStorageService().getData("Base64Response");
    Base64 obj = base64FromJson(jsonString!);
    List<dynamic> list = [filePath, obj];
    return list;
  }
}
