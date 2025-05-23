import 'dart:convert';

List<Note> noteFromJson(String str) =>
    List<Note>.from(json.decode(str).map((x) => Note.fromJson(x)));

String noteToJson(List<Note> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Note {
  String? text;
  String? cfi;
  String? note;

  Note({
    this.text,
    this.cfi,
    this.note,
  });

  Note copyWith({
    String? text,
    String? cfi,
    String? note,
  }) =>
      Note(
        text: text ?? this.text,
        cfi: cfi ?? this.cfi,
        note: note ?? this.note,
      );

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        text: json["text"],
        cfi: json["cfi"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "cfi": cfi,
        "note": note,
      };
}
