import 'package:hive/hive.dart';

import 'mdl_chord.dart';
import 'mdl_lyric.dart';

@HiveType(typeId: 1)
class Section {
  @HiveField(0)
  String section;
  @HiveField(1)
  String timestamp;
  @HiveField(2)
  String duration;
  @HiveField(3)
  List<Chord>? chords;
  @HiveField(4)
  List<Lyric>? lyrics;

  Section({
    required this.section,
    required this.timestamp,
    required this.duration,
    this.chords,
    this.lyrics,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    var chordsJson = json['chords'] as List;
    var lyricsJson = json['lyrics'] as List;

    return Section(
      section: json['section'],
      timestamp: json['timestamp'],
      duration: json['duration'],
      chords: chordsJson != null
          ? List<Chord>.from(chordsJson
              .map((x) => Chord.fromJson(Map<String, dynamic>.from(x))))
          : [],
      lyrics: lyricsJson != null
          ? List<Lyric>.from(lyricsJson
              .map((x) => Lyric.fromJson(Map<String, dynamic>.from(x))))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'section': section,
      'timestamp': timestamp,
      'duration': duration,
      'chords': List<dynamic>.from(chords!.map((x) => x.toJson())),
      // ignore: unnecessary_null_comparison
      'lyrics': lyrics != null
          ? List<dynamic>.from(lyrics!.map((x) => x.toJson()))
          : null,
    };
  }
}
