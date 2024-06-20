import 'package:bandbridge/models/mdl_bar.dart';
import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

@HiveType(typeId: 1)

///A Section is a part of a song such as Verse, Chorus, Bridge, etc.
///
///A Section is made up of Bars. Each Bar is made up of Beats.
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
  @HiveField(4)
  List<Lyric>? unsynchronisedLyrics;

  Section({
    this.section = '',
    this.timestamp = '',
    this.duration = '',
    List<Bar>? bars,
    List<Lyric>? unsynchronisedLyrics,
  })  : bars = bars ?? [],
        unsynchronisedLyrics = unsynchronisedLyrics ?? [];

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      section: json['section'] ?? '',
      timestamp: json['timestamp'] ?? '',
      duration: json['duration'] ?? '',
      bars: (json['bars'] as List<dynamic>?)
          ?.map((barJson) => Bar.fromJson(barJson))
          .toList(),
      unsynchronisedLyrics: List<Lyric>.from(json['unsynchronisedLyrics']
          .map((x) => Lyric.fromJson(Map<String, dynamic>.from(x)))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'section': section,
      'timestamp': timestamp,
      'duration': duration,
      'bars': bars?.map((bar) => bar.toJson()).toList(),
      'unsynchronisedLyrics': unsynchronisedLyrics
          ?.map((unsynchronisedLyrics) => unsynchronisedLyrics.toJson())
          .toList(),
    };
  }

  void addBar(Bar newBar) {
    bars ??= [];

    bars?.add(newBar);
  }

  ///Adds a lyric to the unsynchronisedLyrics list. This is used when moving lyrics between sections.
  ///
  ///This does not assign the lyric to a beat or bar. It only places the lyric into the sections' unsynchronisedLyrics list.
  void addLyric(Lyric lyric) {
    unsynchronisedLyrics ??= [];

    unsynchronisedLyrics?.add(lyric);
  }

  ///Adds a list of lyrics to the unsynchronisedLyrics list. This is used when moving lyrics between sections.
  ///
  ///This replaces all lyrics currently in the unsynchronisedLyrics list
  void addLyrics(List<Lyric> lyricsToMove) {
    unsynchronisedLyrics ??= [];

    unsynchronisedLyrics = lyricsToMove;
  }
}
