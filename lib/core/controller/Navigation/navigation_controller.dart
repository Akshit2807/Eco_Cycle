import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final PageController pageController = PageController(initialPage: 0);

  void changePage(int index) {
    selectedIndex.value = index;
    pageController.jumpToPage(index);
  }
}
