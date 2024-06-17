import 'package:bandbridge/models/mdl_version.dart';
import 'package:hive_flutter/hive_flutter.dart';

class VersionAdapter extends TypeAdapter<Version> {
  @override
  final typeId = 4;
  static const int currentVersion = 1;

  @override
  Version read(BinaryReader reader) {
    int version = reader.readByte();

    print(version);

    version = 1;

    print(version);

    switch (currentVersion) {
      case 1:
        return Version(
          hash: reader.read(),
          epoch: reader.read(),
        );
      default:
        throw Exception('Unknown version');
    }
  }

  @override
  void write(BinaryWriter writer, Version obj) {
    writer.writeByte(currentVersion);
    writer.write(obj.hash);
    writer.write(obj.epoch);
  }
}
