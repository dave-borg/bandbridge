
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 3)
class Lyric {
  @HiveField(0)
  String text;
  @HiveField(2)
  String beats;

  Lyric({
    required this.text,
    required this.beats,
  });

  factory Lyric.fromJson(Map<String, dynamic> json) {
    return Lyric(
      text: json['text'],
      beats: json['beats'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'beats': beats,
    };
  }
}
