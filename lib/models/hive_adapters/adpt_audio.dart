import 'package:bandbridge/models/mdl_audio.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AudioTrackAdapter extends TypeAdapter<AudioTrack> {
  @override
  final int typeId = 8;

  @override
  AudioTrack read(BinaryReader reader) {
    return AudioTrack(
      trackName: reader.read(),
      fileName: reader.read(),
      volume: reader.read(),
      foh: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, AudioTrack obj) {
    writer.write(obj.trackName);
    writer.write(obj.fileName);
    writer.write(obj.volume);
    writer.write(obj.foh);
  }
}