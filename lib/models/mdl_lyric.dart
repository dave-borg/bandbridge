import 'package:hive/hive.dart';

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

class Version {
  String hash;
  String epoch;

  Version({
    required this.hash,
    required this.epoch,
  });

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      hash: json['hash'],
      epoch: json['epoch'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hash': hash,
      'epoch': epoch,
    };
  }
}
