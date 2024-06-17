import 'package:bandbridge/models/mdl_beat.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BeatAdapter extends TypeAdapter<Beat> {
  @override
  final typeId = 7;
  static const int currentVersion = 1;

  @override
  Beat read(BinaryReader reader) {
    final int version = reader.readByte();

    switch (version) {
      case 1:
        return Beat(
          chord: reader.read(),
          lyric: reader.read(),
        );
      default:
        throw Exception('Unknown version');
    }
  }

  @override
  void write(BinaryWriter writer, Beat obj) {
    writer.writeByte(currentVersion);
    writer.write(obj.chord);
    writer.write(obj.lyric);
  }
}
