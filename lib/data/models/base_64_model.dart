// To parse this JSON data, do
//
//     final base64 = base64FromJson(jsonString);

import 'dart:convert';

Base64 base64FromJson(String str) => Base64.fromJson(json.decode(str));

String base64ToJson(Base64 data) => json.encode(data.toJson());

class Base64 {
  final String title;
  final String desc;
  final List<String> searchTags;
  final String category;

  Base64({
    required this.title,
    required this.desc,
    required this.searchTags,
    required this.category,
  });

  factory Base64.fromJson(Map<String, dynamic> json) => Base64(
        title: json["title"],
        desc: json["desc"],
        searchTags: List<String>.from(json["search_tags"].map((x) => x)),
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "desc": desc,
        "search_tags": List<dynamic>.from(searchTags.map((x) => x)),
        "category": category,
      };
}
