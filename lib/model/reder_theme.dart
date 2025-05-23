import 'dart:convert';

List<ReaderTheme> readerThemeFromJson(String str) =>
    List<ReaderTheme>.from(json.decode(str).map((x) => ReaderTheme.fromJson(x)));

String readerThemeToJson(List<ReaderTheme> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReaderTheme {
  int fgColor;
  int bgColor;
  String? name;

  ReaderTheme({
    required this.fgColor,
    required this.bgColor,
    this.name,
  });

  ReaderTheme copyWith({
    int? fgColor,
    int? bgColor,
    String? name,
  }) =>
      ReaderTheme(
        fgColor: fgColor ?? this.fgColor,
        bgColor: bgColor ?? this.bgColor,
        name: name ?? this.name,
      );

  factory ReaderTheme.fromJson(Map<String, dynamic> json) => ReaderTheme(
        fgColor: json["fgColor"],
        bgColor: json["bgColor"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "fgColor": fgColor,
        "bgColor": bgColor,
        "name": name,
      };
}
