import 'package:bandbridge/models/mdl_chord.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChordAdapter extends TypeAdapter<Chord> {
  @override
  final typeId = 2;

  @override
  Chord read(BinaryReader reader) {
    return Chord(
      rootNote: reader.read(),
      beats: reader.read(),
      chordQuality: reader.read(),
      chordExtension: reader.read(),
      bass: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Chord obj) {
    writer.write(obj.rootNote);
    writer.write(obj.beats);
    writer.write(obj.chordQuality);
    writer.write(obj.chordExtension);
    writer.write(obj.bass);
  }
}
