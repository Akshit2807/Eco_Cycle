import 'package:e_waste/core/utils/custom_nav_bar.dart';
import 'package:e_waste/widgets/percentage_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RxInt _selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Text('Content for index ${_selectedIndex.value}'),
      ),

      /// Bottom Bar Centre Button
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: CustomBottomNavigationCentreButton(),

      /// Bottom Nav Bar
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
