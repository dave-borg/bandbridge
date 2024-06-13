import 'package:bandbridge/models/mdl_chord.dart';

class DiatonicChords {
  static const List<String> chromaticScale = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B'
  ];

  static const List<int> majorScalePattern = [0, 2, 4, 5, 7, 9, 11, 12];
  static const List<int> minorScalePattern = [0, 2, 3, 5, 7, 8, 10, 12];

  static const List<ChordType> majorChordPattern = [
    ChordType.major,
    ChordType.minor,
    ChordType.minor,
    ChordType.major,
    ChordType.major,
    ChordType.minor,
    ChordType.diminished,
  ];

  static const List<ChordType> minorChordPattern = [
    ChordType.minor,
    ChordType.diminished,
    ChordType.major,
    ChordType.minor,
    ChordType.minor,
    ChordType.major,
    ChordType.major,
  ];

  static Chord getDiatonicChord(
      String key, ChordType chordType, int scaleDegree) {
    // Find the starting index of the key in the chromatic scale
    final int keyIndex = chromaticScale.indexOf(key);

    // Select the scale pattern based on the chord type
    final List<int> scalePattern =
        chordType == ChordType.major ? majorScalePattern : minorScalePattern;

    // Calculate the note index in the chromatic scale based on the scale degree
    final int noteIndex =
        (keyIndex + scalePattern[scaleDegree]) % chromaticScale.length;
    final String chordBaseNote = chromaticScale[noteIndex];

    // Determine the chord type for the scale degree
    final List<ChordType> pattern =
        chordType == ChordType.major ? majorChordPattern : minorChordPattern;
    final ChordType degreeChordType = pattern[scaleDegree];

    // Construct the chord name based on the base note and the chord type
    Chord rValue = Chord(rootNote: chordBaseNote, beats: '1');
    if (degreeChordType == ChordType.minor) {
      rValue.chordQuality = ChordType.minor.index;
    } else if (degreeChordType == ChordType.major) {
      rValue.chordQuality = ChordType.major.index;
    } else if (degreeChordType == ChordType.diminished) {
      rValue.chordQuality = ChordType.diminished.index;
    }

    return rValue;
  }
}

enum ChordType { major, minor, diminished }
