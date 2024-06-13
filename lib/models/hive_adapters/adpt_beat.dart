import 'package:bandbridge/models/mdl_beat.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BeatAdapter extends TypeAdapter<Beat> {
  @override
  final typeId = 7;

  @override
  Beat read(BinaryReader reader) {
    return Beat(
      chord: reader.read(),
      lyric: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Beat obj) {
    writer.write(obj.chord);
    writer.write(obj.lyric);
  }
}
