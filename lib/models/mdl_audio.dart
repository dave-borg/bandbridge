
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 8)
class AudioTrack extends HiveObject  {
  @HiveField(0)
  String trackName;
  @HiveField(1)
  String fileName;
  @HiveField(2)
  double volume;
  @HiveField(3)
  bool foh;

  AudioTrack({
    this.trackName = "",
    this.fileName = "",
    this.volume = 75.0,
    this.foh = true,
  });

  factory AudioTrack.fromJson(Map<String, dynamic> json) {
    return AudioTrack(
      trackName: json['trackName'] ?? "",
      fileName: json['fileName'] ?? "",
      volume: json['volume'] ?? "",
      foh: json['foh'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trackName': trackName,
      'fileName': fileName,
      'volume': volume,
      'foh': foh,
    };
  }
}