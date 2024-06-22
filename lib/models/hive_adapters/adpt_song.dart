import 'package:bandbridge/models/mdl_audio.dart';
import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SongAdapter extends TypeAdapter<Song> {
  @override
  final typeId = 0;
  static const int currentVersion = 2;

  @override
  Song read(BinaryReader reader) {
    int currentVersion = reader.readByte();

    switch (currentVersion) {
      case 1:

        return Song(
          songId: reader.read(),
          title: reader.read(),
          artist: reader.read(),
          duration: reader.read(),
          initialKey: reader.read(),
          tempo: reader.read(),
          timeSignature: reader.read(),
          sections: reader.readList().cast<Section>(),
          unsynchronisedLyrics: reader.readList().cast<Lyric>(),
          audioTracks: reader.readList().cast<AudioTrack>(),
        );

      case 2:
      return Song(
          songId: reader.read(),
          title: reader.read(),
          artist: reader.read(),
          duration: reader.read(),
          initialKey: reader.read(),
          tempo: reader.read(),
          timeSignature: reader.read(),
          sections: reader.readList().cast<Section>(),
          unsynchronisedLyrics: reader.readList().cast<Lyric>(),
          audioTracks: reader.readList().cast<AudioTrack>(),
        );
      default:
        throw Exception('Unknown version');
    }
  }

  @override
  void write(BinaryWriter writer, Song obj) {
    writer.writeByte(currentVersion);
    writer.write(obj.id);
    writer.write(obj.title);
    writer.write(obj.artist);
    writer.write(obj.duration);
    writer.write(obj.initialKey);
    writer.write(obj.tempo);
    writer.write(obj.timeSignature);
    writer.writeList(obj.sections);
    writer.writeList(obj.unsynchronisedLyrics);
    writer.writeList(obj.audioTracks);
  }
}
