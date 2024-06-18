import 'package:bandbridge/models/mdl_bar.dart';
import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

@HiveType(typeId: 1)
class Section {
  var logger = Logger(level: LoggingUtil.loggingLevel('Section'));
  @HiveField(0)
  String section;
  @HiveField(1)
  String timestamp;
  @HiveField(2)
  String duration;
  @HiveField(3)
  List<Bar>? bars;

  Section({
    this.section = '',
    this.timestamp = '',
    this.duration = '',
    List<Bar>? bars,
  }) : bars = bars ?? [];

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      section: json['section'] ?? '',
      timestamp: json['timestamp'] ?? '',
      duration: json['duration'] ?? '',
      bars: (json['bars'] as List<dynamic>?)
          ?.map((barJson) => Bar.fromJson(barJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'section': section,
      'timestamp': timestamp,
      'duration': duration,
      'bars': bars?.map((bar) => bar.toJson()).toList(),
    };
  }

  void addBar(Bar newBar) {
    bars ??= [];

    bars?.add(newBar);
  }

  void setLyrics(List<Lyric> droppedAndTrailingLyrics) {
    int linesOfLyrics = droppedAndTrailingLyrics.length;
    int barsInThisSection = bars!.length;

    //Naive way to set lyrics to bars. Distribute evenly across the bars.
    int barsPerLyric = barsInThisSection ~/ linesOfLyrics;

    for (var i = 0; i < droppedAndTrailingLyrics.length; i++) {
      logger.d(
          "bars[$barsPerLyric * $i] = droppedAndTrailingLyrics[i]: ${droppedAndTrailingLyrics[i].text}");
      bars![barsPerLyric * i].beats[0].lyric = droppedAndTrailingLyrics[i];
    }
  }
}
