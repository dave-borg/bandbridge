
import 'package:bandbridge/music_theory/chord_modifiers.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 2)
class Chord extends HiveObject {
  @HiveField(0)
  String rootNote;
  @HiveField(1)
  String beats;
  @HiveField(3)
  String? bass;
  @HiveField(4)
  int? chordQuality;
  @HiveField(5)
  int? chordExtension;

  Chord({
    required this.rootNote,
    required this.beats,
    this.bass,
    this.chordQuality,
    this.chordExtension,
  });

  factory Chord.fromJson(Map<String, dynamic> json) {
    return Chord(
      rootNote: json['name'],
      beats: json['beats'],
      bass: json['bass'],
      chordQuality: json['chordQuality'] as int,
      chordExtension: json['chordExtension'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': rootNote,
      'beats': beats,
      'bass': bass,
      'chordQuality': chordQuality,
      'chordExtension': chordExtension,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  /// This returns a string of the chord modifiers such as m, 7, 9, etc.
  renderElements() {
    String rValue = "";
    if (chordQuality != null) {
      rValue += ChordModifiers.render(chordQuality!);
    }
    if (chordExtension != null) {
      rValue += ChordModifiers.render(chordExtension!);
    }
    return rValue;
  }

  /// This returns the full chord name including the root note and modifiers. For example it will return G7 for a G minor 7 chord.
  renderFullChord() {
    return rootNote + renderElements();
  }

  copy() {
    return Chord(
      rootNote: rootNote,
      beats: beats,
      bass: bass,
      chordQuality: chordQuality,
      chordExtension: chordExtension,
    );
  }

}
