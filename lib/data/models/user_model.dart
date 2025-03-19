import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  UserModel({
    // required this.userId,
    required this.username,
    required this.email,
  });

  // @HiveField(0)
  // String userId;

  @HiveField(1)
  String username;

  @HiveField(2)
  String email;
}
