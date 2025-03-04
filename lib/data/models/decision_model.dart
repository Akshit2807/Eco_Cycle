// To parse this JSON data, do
//
//     final decision = decisionFromJson(jsonString);

import 'dart:convert';

Decision decisionFromJson(String str) => Decision.fromJson(json.decode(str));

String decisionToJson(Decision data) => json.encode(data.toJson());

class Decision {
  final String decision;
  final String guide;

  Decision({
    required this.decision,
    required this.guide,
  });

  factory Decision.fromJson(Map<String, dynamic> json) => Decision(
        decision: json["decision"],
        guide: json["guide"],
      );

  Map<String, dynamic> toJson() => {
        "decision": decision,
        "guide": guide,
      };
}
