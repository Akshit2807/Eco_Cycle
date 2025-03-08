import 'package:e_waste/viewmodels/auth_viewmodel.dart';
import 'package:e_waste/viewmodels/community_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => CommunityViewModel()),
        // TODO: Added CommunityViewModel.
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Waste',
        initialRoute: '/',
        onGenerateRoute: RouteNavigation.generateRoute,
        color: Colors.white,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
