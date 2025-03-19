import 'package:get/get.dart';

class DrawerControllerX extends GetxController {
  var selectedIndex = 0.obs; // Observable variable

  void updateIndex(int index) {
    selectedIndex.value = index;
  }
}
