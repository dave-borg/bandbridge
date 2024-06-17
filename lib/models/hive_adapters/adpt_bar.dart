import 'package:bandbridge/models/mdl_beat.dart';
import 'package:bandbridge/models/mdl_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BarAdapter extends TypeAdapter<Bar> {
  @override
  final typeId = 6;
  static const int currentVersion = 1;

  @override
  Bar read(BinaryReader reader) {
    final int version = reader.readByte();

    switch (version) {
      case 1:
        return Bar(
          beats: reader.readList().cast<Beat>(),
          timeSignature: reader.read(),
          songId: reader.read(),
        );
      default:
        throw Exception('Unknown version');
    }
  }

  @override
  void write(BinaryWriter writer, Bar obj) {
    writer.writeByte(currentVersion);
    writer.writeList(obj.beats);
    writer.write(obj.timeSignature);
    writer.write(obj.id);
  }
}
