import 'package:bandbridge/models/mdl_chord.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChordAdapter extends TypeAdapter<Chord> {
  @override
  final typeId = 2;

  @override
  Chord read(BinaryReader reader) {
    return Chord(
      name: reader.read(),
      beats: reader.read(),
      modifications: reader.read(),
      bass: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Chord obj) {
    writer.write(obj.name);
    writer.write(obj.beats);
    writer.write(obj.modifications);
    writer.write(obj.bass);
  }
}