import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:bandbridge/models/mdl_version.dart';
import 'package:bandbridge/music_theory/diatonic_chords.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import 'mdl_section.dart';

@HiveType(typeId: 0)
class Song extends HiveObject {
  @HiveField(0)
  String id = "-1";
  @HiveField(1)
  String title = "";
  @HiveField(2)
  String artist = "";
  @HiveField(3)
  String duration = "";
  @HiveField(4)
  String initialKey = "";
  @HiveField(5)
  String tempo = "";
  @HiveField(6)
  String timeSignature = "";
  @HiveField(7)
  List<Section> sections;
  @HiveField(8)
  List<Version>? versions;
  @HiveField(9)
  ChordType initialKeyType;
  @HiveField(10)
  List<Lyric> unsynchronisedLyrics;

  Song({
    String? songId,
    this.title = "[Title]",
    this.artist = "[Artist]",
    this.duration = "",
    this.initialKey = "",
    this.tempo = "",
    this.timeSignature = "",
    List<Section>? sections,
    List<Lyric>? unsynchronisedLyrics,
    // this.versions = const [],
  })  : id = songId == null || songId == "-2" ? const Uuid().v4() : songId,
        initialKeyType =
            initialKey.endsWith('m') ? ChordType.minor : ChordType.major,
        sections = sections ?? [],
        unsynchronisedLyrics = unsynchronisedLyrics ??
            []; // Initialize structure in the constructor body

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      songId: json['id'],
      title: json['title'],
      artist: json['artist'],
      duration: json['duration'],
      initialKey: json['initialKey'],
      tempo: json['tempo'],
      timeSignature: json['timeSignature'],
      sections: List<Section>.from(
        json['structure']
            .map((x) => Section.fromJson(Map<String, dynamic>.from(x))),
      ),
      unsynchronisedLyrics: List<Lyric>.from(
        json['unsynchronisedLyrics']
            .map((x) => Lyric.fromJson(Map<String, dynamic>.from(x))),
      ),
      // versions: List<Version>.from(
      //   json['versions']
      //       .map((x) => Version.fromJson(Map<String, dynamic>.from(x))),
      // ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'duration': duration,
      'initialKey': initialKey,
      'tempo': tempo,
      'timeSignature': timeSignature,
      'sections': List<dynamic>.from(sections.map((x) => x.toJson())),
      'unsynchronisedLyrics':
          List<dynamic>.from(unsynchronisedLyrics.map((x) => x.toJson())),
    };
  }

  String getDebugOutput([String debugTitle = 'Song']) {
    var rValue = "$debugTitle\n";
    rValue += "--------------\n";
    rValue += "ID: $id\n";
    rValue += "Title: $title\n";
    rValue += "Artist: $artist\n";
    rValue += "Duration: $duration\n";
    rValue += "Initial Key: $initialKey\n";
    rValue += "Initial Key Type: $initialKeyType\n";
    rValue += "Tempo: $tempo\n";
    rValue += "Time Signature: $timeSignature\n";
    rValue += "Sections: ${sections.length}\n";
    rValue += "Unsynchronised Lyrics: ${unsynchronisedLyrics.length}\n";
    // rValue += "Versions: ${versions.length}\n";

    return rValue;
  }

  addStructure(Section section) {
    sections.add(section);
  }

  void deleteAllLyrics() {
    for (var thisSection in sections) {
      thisSection.unsynchronisedLyrics = [];
      for (var thisBar in thisSection.bars!) {
        for (var thisBeat in thisBar.beats) {
          thisBeat.lyric = null;
        }
      }
    }
    unsynchronisedLyrics = [];
  }
}
