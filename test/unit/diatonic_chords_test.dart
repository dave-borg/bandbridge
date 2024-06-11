import 'package:bandbridge/music_theory/diatonic_chords.dart';
import 'package:test/test.dart';

void main() {
  group('Diatonic Chords', () {
    test('Major scale chords in C - 2nd', () {
      final chord = DiatonicChords.getDiatonicChord('C', ChordType.major, 2);
      expect(chord.name, 'Dm');
      expect(chord.beats, '1');
    });

    test('Major scale chords in C - 7th', () {
      final chord = DiatonicChords.getDiatonicChord('C', ChordType.major, 7);
      expect(chord.name, 'Bdim');
      expect(chord.beats, '1');
    });

    test('Minor scale chords in A - 3rd', () {
      final chord = DiatonicChords.getDiatonicChord('A', ChordType.minor, 3);
      expect(chord.name, 'C');
      expect(chord.beats, '1');
    });

    test('Minor scale chords in A - 2nd', () {
      final chord = DiatonicChords.getDiatonicChord('A', ChordType.minor, 2);
      expect(chord.name, 'Bdim');
      expect(chord.beats, '1');
    });

    // Add more tests for different keys and chord types as needed
  });
}
