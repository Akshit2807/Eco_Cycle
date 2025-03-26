import 'dart:convert';

class Decision {
  final String decision;
  final Guide guide;

  Decision({
    required this.decision,
    required this.guide,
  });

  factory Decision.fromRawJson(String str) =>
      Decision.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Decision.fromJson(Map<String, dynamic> json) => Decision(
        decision: json["decision"],
        guide: Guide.fromJson(json["guide"]),
      );

  Map<String, dynamic> toJson() => {
        "decision": decision,
        "guide": guide.toJson(),
      };
}

class Guide {
  final String initials;
  final Pointers pointers;

  Guide({
    required this.initials,
    required this.pointers,
  });

  factory Guide.fromRawJson(String str) => Guide.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Guide.fromJson(Map<String, dynamic> json) => Guide(
        initials: json["initials"],
        pointers: Pointers.fromJson(json["pointers"]),
      );

  Map<String, dynamic> toJson() => {
        "initials": initials,
        "pointers": pointers.toJson(),
      };
}

class Pointers {
  final List<String> headings;
  final List<String> description;

  Pointers({
    required this.headings,
    required this.description,
  });

  factory Pointers.fromRawJson(String str) =>
      Pointers.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pointers.fromJson(Map<String, dynamic> json) => Pointers(
        headings: List<String>.from(json["headings"].map((x) => x)),
        description: List<String>.from(json["description"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "headings": List<dynamic>.from(headings.map((x) => x)),
        "description": List<dynamic>.from(description.map((x) => x)),
      };
}
