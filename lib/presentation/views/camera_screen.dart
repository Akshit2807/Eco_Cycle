import 'dart:convert';

import 'package:e_waste/core/services/camera_service.dart';
import 'package:e_waste/core/utils/app_loader.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  final String base64Image;
  const CameraScreen({super.key, required this.base64Image});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool loading = true;
  late Future<String> _response;
  @override
  void initState() {
    _response = CameraService.getCategory(base64Image: widget.base64Image);
    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: _response.whenComplete(
            () => Future.delayed(const Duration(milliseconds: 100))),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            final String response =
                jsonDecode(snapshot.data.toString()).toString();
            return Center(
              child: Text(response),
            );
          } else {
            return const Center(
              child: AppLoader(),
            );
          }
        },
      ),
    );
  }
}
