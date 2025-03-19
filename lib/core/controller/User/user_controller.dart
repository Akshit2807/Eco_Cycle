import 'package:get/get.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';

class UserController extends GetxController {
  final UserRepository _userRepository =
      UserRepository(); // Corrected class name
  final Rxn<UserModel> userModel = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      userModel.value = await _userRepository.fetchUserDetails();
    } catch (e) {
      print("Error fetching user: $e");
    }
  }
}
