import 'package:bandbridge/models/mdl_section.dart';
import 'package:hive/hive.dart';

class SectionAdapter extends TypeAdapter<Section> {
  @override
  final typeId = 1;

  @override
  Section read(BinaryReader reader) {
    return Section(
      section: reader.read(),
      timestamp: reader.read(),
      duration: reader.read(),
      chords: reader.read(),
      lyrics: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Section obj) {
    writer.write(obj.section);
    writer.write(obj.timestamp);
    writer.write(obj.duration);
    writer.write(obj.chords);
    writer.write(obj.lyrics);
  }
}