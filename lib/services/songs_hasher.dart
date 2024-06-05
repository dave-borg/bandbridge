import 'dart:convert';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';

class SongHasher {
  static String hashSong(Song song) {
    var logger = Logger(level: LoggingUtil.loggingLevel('SongHasher'));
    logger.i('Hashing song: ${song.title}');

    var songString = "";

    songString += song.title;
    songString += song.artist;
    songString += song.duration;
    songString += song.duration;
    songString += song.initialKey;
    songString += song.tempo;
    songString += song.timeSignature;

    for (var section in song.structure) {
      songString += section.section;
      songString += section.timestamp;
      songString += section.duration;

      for (var chord in section.chords!) {
        songString += chord.name;

        if (chord.modifications != null) songString += chord.modifications!;

        songString += chord.beats;

        if (chord.bass != null) songString += chord.bass!;
      }

      for (var lyric in section.lyrics!) {
        songString += lyric.text;
        songString += lyric.beats;
      }
    }

    logger.d('Song string: $songString');

    final bytes = utf8.encode(songString);
    final hash = sha256.convert(bytes);

    logger.d('Hashed song: ${hash.toString()}');

    return hash.toString();
  }
}
