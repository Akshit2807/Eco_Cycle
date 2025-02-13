import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Waste',
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
