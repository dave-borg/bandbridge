import 'package:bandbridge/models/mdl_chord.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChordAdapter extends TypeAdapter<Chord> {
  @override
  final typeId = 2;
  static const int currentVersion = 1;

  @override
  Chord read(BinaryReader reader) {
    final int version = reader.readByte();

    switch (version) {
      case 1:
        return Chord(
          rootNote: reader.read(),
          beats: reader.read(),
          chordQuality: reader.read(),
          chordExtension: reader.read(),
          bass: reader.read(),
        );
      default:
        throw Exception('Unknown version');
    }
  }

  @override
  void write(BinaryWriter writer, Chord obj) {
    writer.writeByte(currentVersion);
    writer.write(obj.rootNote);
    writer.write(obj.beats);
    writer.write(obj.chordQuality);
    writer.write(obj.chordExtension);
    writer.write(obj.bass);
  }
}
