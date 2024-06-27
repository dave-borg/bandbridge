import 'package:bandbridge/models/mdl_beat.dart';
import 'package:bandbridge/models/mdl_chord.dart';
import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

@HiveType(typeId: 6)
class Bar {
  @HiveField(0)
  List<Beat> beats = [];
  @HiveField(1)
  String timeSignature = "4/4";
  @HiveField(2)
  String id = "-1";
  @HiveField(3)
  int startTimeMs = -1;
  @HiveField(4)
  int calculatedStartTimeMs = -1;

  Bar({List<Beat>? beats, String? timeSignature = "4/4", String? songId, int? startTimeMs, int? calculatedStartTimeMs})
      : id = songId == null || songId == "-2" ? const Uuid().v4() : songId {
    if (beats != null) {
      this.beats = beats;
    } else {
      initBeats();
    }
  }

  factory Bar.fromJson(Map<String, dynamic> json) {
    List<Beat> beats = [];
    if (json['beats'] != null) {
      json['beats'].forEach((beatJson) {
        beats.add(Beat.fromJson(beatJson));
      });
    }
    return Bar(
      beats: beats,
      timeSignature: json['timeSignature'] ?? "4/4",
      startTimeMs: json['startTimeMs'],
      calculatedStartTimeMs: json['calculatedStartTimeMs'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> beatsJson = [];
    for (var beat in beats) {
      beatsJson.add(beat.toJson());
    }
    return {
      'beats': beatsJson,
      'timeSignature': timeSignature,
      'id': id,
      'startTimeMs': startTimeMs,
      'calculatedStartTimeMs': calculatedStartTimeMs,
    };
  }

  int getNumerator() {
    return int.parse(timeSignature.split("/")[0]);
  }

  void initBeats() {
    for (int i = 0; i < getNumerator(); i++) {
      beats.add(Beat());
    }
  }

  Bar setChord(int beatIndex, Chord chord) {
    beats[beatIndex].chord = chord;
    return this;
  }

  void setLyric(int beatIndex, Lyric lyric) {
    beats[beatIndex].lyric = lyric;
  }

  void removeChord(int beatIndex) {
    beats[beatIndex].chord = null;
  }

  void removeLyric(int beatIndex) {
    beats[beatIndex].lyric = null;
  }

  Chord getChord(int beatIndex) {
    return beats[beatIndex].chord!;
  }

  Lyric getLyric(int beatIndex) {
    return beats[beatIndex].lyric!;
  }

  expand(List<Widget> Function(dynamic beats) param0) {
    return beats;
  }

  String getDebugOutput(String debugHeader) {
    String debugOutput = "$debugHeader\n\n";
    for (int i = 0; i < beats.length; i++) {
      debugOutput += "Beat $i: ";
      if (beats[i].chord != null) {
        debugOutput += "Chord: ${beats[i].chord!.renderFullChord()} ";
      }
      if (beats[i].lyric != null) {
        debugOutput += "Lyric: ${beats[i].lyric!.text} ";
      }
      debugOutput += "\n";
    }
    debugOutput += "StartTimeMs: ${startTimeMs}\n";
    debugOutput += "CalculatedStartTimeMs: ${calculatedStartTimeMs}\n";
    return debugOutput;
  }

  copy() {
    List<Beat> copiedBeats = [];
    for (var beat in beats) {
      copiedBeats.add(beat.copy());
    }
    return Bar(beats: copiedBeats, timeSignature: timeSignature, songId: id, startTimeMs: startTimeMs, calculatedStartTimeMs: calculatedStartTimeMs);
  }
}
