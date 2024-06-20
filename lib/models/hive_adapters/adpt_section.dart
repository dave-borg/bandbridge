import 'package:bandbridge/models/mdl_bar.dart';
import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:bandbridge/models/mdl_section.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SectionAdapter extends TypeAdapter<Section> {
  @override
  final typeId = 1;

  @override
  Section read(BinaryReader reader) {
    return Section(
      section: reader.read(),
      timestamp: reader.read(),
      duration: reader.read(),
      bars: reader.readList().cast<Bar>(),
      unsynchronisedLyrics: reader.readList().cast<Lyric>(),
    );
  }

  @override
  void write(BinaryWriter writer, Section obj) {
    writer.write(obj.section);
    writer.write(obj.timestamp);
    writer.write(obj.duration);
    writer.writeList(obj.bars ?? []);
    writer.writeList(obj.unsynchronisedLyrics ?? []);
  }
}
