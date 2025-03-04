// To parse this JSON data, do
//
//     final quetions = quetionsFromJson(jsonString);

import 'dart:convert';

Quetions quetionsFromJson(String str) => Quetions.fromJson(json.decode(str));

String quetionsToJson(Quetions data) => json.encode(data.toJson());

class Quetions {
  final List<String> questions;

  Quetions({
    required this.questions,
  });

  factory Quetions.fromJson(Map<String, dynamic> json) => Quetions(
        questions: List<String>.from(json["questions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "questions": List<dynamic>.from(questions.map((x) => x)),
      };
}
