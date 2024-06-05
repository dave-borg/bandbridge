import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:hive/hive.dart';

class LyricAdapter extends TypeAdapter<Lyric> {
  @override
  final typeId = 3;

  @override
  Lyric read(BinaryReader reader) {
    return Lyric(
      text: reader.read(),
      beats: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Lyric obj) {
    writer.write(obj.text);
    writer.write(obj.beats);
  }
}
