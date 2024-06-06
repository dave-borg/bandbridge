import 'package:bandbridge/models/mdl_version.dart';
import 'package:hive_flutter/hive_flutter.dart';

class VersionAdapter extends TypeAdapter<Version> {
  @override
  final typeId = 4;

  @override
  Version read(BinaryReader reader) {
    return Version(
      hash: reader.read(),
      epoch: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Version obj) {
    writer.write(obj.hash);
    writer.write(obj.epoch);
  }
}