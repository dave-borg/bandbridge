import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LyricAdapter extends TypeAdapter<Lyric> {
  @override
  final typeId = 3;
  static const int currentVersion = 1;

  @override
  Lyric read(BinaryReader reader) {
    final int version = reader.readByte();

    switch (version) {
      case 1:
        return Lyric(
          text: reader.read(),
          beats: reader.read(),
        );
      default:
        throw Exception('Unknown version');
    }
  }

  @override
  void write(BinaryWriter writer, Lyric obj) {
    writer.writeByte(currentVersion);
    writer.write(obj.text);
    writer.write(obj.beats);
  }
}
