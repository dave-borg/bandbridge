
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 3)
class Lyric extends HiveObject {
  @HiveField(0)
  String text;
  @HiveField(2)
  String beats;
  @HiveField(3)
  int startTimeMs;
  @HiveField(4)
  int calculatedStartTimeMs;
  @HiveField(5)
  bool isHighlighted = false;

  Lyric({
    required this.text,
    required this.beats,
    this.startTimeMs = -1,
    this.calculatedStartTimeMs = -1,
  });

  factory Lyric.fromJson(Map<String, dynamic> json) {
    return Lyric(
      text: json['text'],
      beats: json['beats'],
      startTimeMs: json['startTimeMs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'beats': beats,
      'startTimeMs': startTimeMs,
    };
  }

  copy() {
    return Lyric(
      text: text,
      beats: beats,
      startTimeMs: -1,
    );
  }
}
