import 'package:bandbridge/models/mbl_beat.dart';
import 'package:bandbridge/models/mdl_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SectionAdapter extends TypeAdapter<Bar> {
  @override
  final typeId = 6;

  @override
  Bar read(BinaryReader reader) {
    return Bar(
      beats: reader.readList().cast<Beat>(),
      timeSignature: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Bar obj) {
    writer.write(obj.beats);
    writer.write(obj.timeSignature);
  }
}
