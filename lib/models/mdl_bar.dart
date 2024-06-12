import 'package:bandbridge/models/mbl_beat.dart';
import 'package:bandbridge/models/mdl_chord.dart';
import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 6)
class Bar {
  @HiveField(0)
  List<Beat> beats = [];
  @HiveField(1)
  String timeSignature = "4/4";

  Bar({List<Beat>? beats, String? timeSignature = "4/4"}) {
    initBeats();
  }

  factory Bar.fromJson(Map<String, dynamic> json) {
    Bar bar = Bar();
    bar.beats = (json['beats'] as List<dynamic>).map((beatJson) {
      Chord? chord =
          beatJson['chord'] != null ? Chord.fromJson(beatJson['chord']) : null;
      Lyric? lyric =
          beatJson['lyric'] != null ? Lyric.fromJson(beatJson['lyric']) : null;
      return Beat(chord: chord, lyric: lyric);
    }).toList();
    bar.timeSignature = json['timeSignature'];
    return bar;
  }

  Map<String, dynamic> toJson() {
    List<dynamic> beatsJson = beats.map((beat) {
      Map<String, dynamic> beatJson = {};
      if (beat.chord != null) {
        beatJson['chord'] = beat.chord!.toJson();
      }
      if (beat.lyric != null) {
        beatJson['lyric'] = beat.lyric!.toJson();
      }
      return beatJson;
    }).toList();
    return {
      'beats': beatsJson,
      'timeSignature': timeSignature,
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
}
