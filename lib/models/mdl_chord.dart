
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 2)
class Chord {
  @HiveField(0)
  String name;
  @HiveField(1)
  String beats;
  @HiveField(2)
  String? modifications = "";
  @HiveField(3)
  String? bass;

  Chord({
    required this.name,
    required this.beats,
    this.modifications,
    this.bass,
  });

  factory Chord.fromJson(Map<String, dynamic> json) {
    return Chord(
      name: json['name'],
      beats: json['beats'],
      modifications: json['modifications'],
      bass: json['bass'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'beats': beats,
      'modifications': modifications,
      'bass': bass,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
