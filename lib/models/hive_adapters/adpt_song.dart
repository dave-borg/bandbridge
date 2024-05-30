import 'package:bandbridge/models/mdl_song.dart';
import 'package:hive/hive.dart';

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
      structure: reader.read(),
      versions: reader.read(),
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
    writer.write(obj.structure);
    writer.write(obj.versions);
  }
}