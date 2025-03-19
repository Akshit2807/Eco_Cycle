// lib/data/repositories/user_repository.dart

import '../../core/services/local_storage_service/hive_service.dart';
import '../models/user_model.dart';

/// Repository responsible for fetching and handling user data
/// Acts as an abstraction layer between ViewModels and the HiveService
class UserRepository {
  /// Fetches user details stored in Hive (returns UserModel or null)
  Future<UserModel?> fetchUserDetails() async {
    try {
      // Calls HiveService to get the user data
      final userModel = await HiveService.getUserModel();
      return userModel;
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

  /// Saves user details (username and email) to Hive
  Future<void> saveUserDetails(UserModel user) async {
    try {
      await HiveService.saveUserModel(user);
    } catch (e) {
      print("Error saving user details: $e");
    }
  }

  /// Clears the user data from Hive storage (use on logout)
  Future<void> clearUserDetails() async {
    try {
      await HiveService.clearUser();
    } catch (e) {
      print("Error clearing user details: $e");
    }
  }
}
