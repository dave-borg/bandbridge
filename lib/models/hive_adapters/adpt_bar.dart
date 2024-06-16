import 'package:bandbridge/models/mdl_beat.dart';
import 'package:bandbridge/models/mdl_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BarAdapter extends TypeAdapter<Bar> {
  @override
  final typeId = 6;

  @override
  Bar read(BinaryReader reader) {
    return Bar(
      beats: reader.readList().cast<Beat>(),
      timeSignature: reader.read(),
      songId: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Bar obj) {
    writer.writeList(obj.beats);
    writer.write(obj.timeSignature);
    writer.write(obj.id);
  }
}
