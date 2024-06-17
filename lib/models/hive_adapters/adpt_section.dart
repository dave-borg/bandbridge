import 'package:bandbridge/models/mdl_bar.dart';
import 'package:bandbridge/models/mdl_section.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SectionAdapter extends TypeAdapter<Section> {
  @override
  final typeId = 1;
  static const int currentVersion = 1;

  @override
  Section read(BinaryReader reader) {
    final int version = reader.readByte();

    switch (version) {
      case 1:
        return Section(
          section: reader.read(),
          timestamp: reader.read(),
          duration: reader.read(),
          bars: reader.readList().cast<Bar>(),
        );
      default:
        throw Exception('Unknown version');
    }
  }

  @override
  void write(BinaryWriter writer, Section obj) {
    writer.writeByte(currentVersion);
    writer.write(obj.section);
    writer.write(obj.timestamp);
    writer.write(obj.duration);
    writer.writeList(obj.bars ?? []);
  }
}
