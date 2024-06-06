
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 3)
class Lyric {
  @HiveField(0)
  String text;
  @HiveField(1)
  String timestamp;

  Lyric({
    required this.text,
    required this.timestamp,
  });

  factory Lyric.fromJson(Map<String, dynamic> json) {
    return Lyric(
      text: json['text'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'timestamp': timestamp,
    };
  }
}
