extension StringExtension on String {
  String get inCaps =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
  String get capitalizeFirstOfEach =>
      split(" ").map((str) => str.inCaps).join(" ");
}
