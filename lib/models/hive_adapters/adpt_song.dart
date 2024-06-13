import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/models/mdl_version.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SongAdapter extends TypeAdapter<Song> {
  @override
  final typeId = 0;

  @override
  Song read(BinaryReader reader) {
    return Song(
      songId: reader.read(),
      title: reader.read(),
      artist: reader.read(),
      duration: reader.read(),
      initialKey: reader.read(),
      tempo: reader.read(),
      timeSignature: reader.read(),
      sections: reader.readList().cast<Section>(),
      versions: reader.readList().cast<Version>(),
    );
  }

  @override
  void write(BinaryWriter writer, Song obj) {
    writer.write(obj.id);
    writer.write(obj.title);
    writer.write(obj.artist);
    writer.write(obj.duration);
    writer.write(obj.initialKey);
    writer.write(obj.tempo);
    writer.write(obj.timeSignature);
    writer.writeList(obj.sections);
    writer.writeList(obj.versions);
  }
}
