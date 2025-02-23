class TxtValidator {
  static final TxtValidator _singleton = TxtValidator._internal();
  factory TxtValidator() {
    return _singleton;
  }
  TxtValidator._internal();

  static String? validatePassword(String? text) {
    if (text == null || text.toString().trim().isEmpty)
      return "Password is required";
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#&*~]).{8,32}$');
    if (!regex.hasMatch(text.toString().trim())) {
      return "Password should be 8-32 character long and must contain at least 1 uppercase letter, 1 lowercase letter, 1 number & 1 special character";
    }
    // if (text.length < 8) return "Password must be at least 8 characters long";
    // if(text.length > 32) return "Password must be at less than 32 characters";
    return null;
  }

  /// Validates email & returns the error message if the email is invalid, if null then email is valid
  static String? validateEmail(String? text) {
    if (text == null || text.toString().trim().isEmpty) {
      return "Email is required";
    }
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!regex.hasMatch(text.toString().trim())) {
      return "Invalid email";
    }
    return null;
  }

  static String? validateNull(String? text) {
    if (text == null || text.toString().trim().isEmpty) {
      return "This feild is required";
    }
    // return null;
  }
}
