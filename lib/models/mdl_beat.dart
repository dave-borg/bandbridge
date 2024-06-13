import 'package:bandbridge/models/mdl_chord.dart';
import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 7)
class Beat {
  @HiveField(0)
  Chord? chord;
  @HiveField(1)
  Lyric? lyric;

  Beat({this.chord, this.lyric});

  Map<String, dynamic> toJson() {
    return {
      'chord': chord?.toJson(),
      'lyric': lyric?.toJson(),
    };
  }

  factory Beat.fromJson(Map<String, dynamic> json) {
    return Beat(
      chord: json['chord'] != null ? Chord.fromJson(json['chord']) : null,
      lyric: json['lyric'] != null ? Lyric.fromJson(json['lyric']) : null,
    );
  }

  Beat copy() {
    return Beat(
      chord: chord?.copy(),
      lyric: lyric?.copy(),
    );
  }
}
