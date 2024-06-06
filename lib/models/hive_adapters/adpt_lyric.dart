import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LyricAdapter extends TypeAdapter<Lyric> {
  @override
  final typeId = 3;

  @override
  Lyric read(BinaryReader reader) {
    return Lyric(
      text: reader.read(),
      timestamp: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Lyric obj) {
    writer.write(obj.text);
    writer.write(obj.timestamp);
  }
}