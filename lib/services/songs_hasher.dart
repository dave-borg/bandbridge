import 'dart:convert';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';

class SongHasher {
  static String hashSong(Song song) {
    var logger = Logger();
    logger.d('Hashing song: ${song.title}');

    var songString = "";

    songString += song.title;
    songString += song.artist;
    songString += song.duration;
    songString += song.duration;
    songString += song.initialKey;
    songString += song.tempo;
    songString += song.timeSignature;

    song.structure.forEach((section) {
      songString += section.section;
      songString += section.timestamp;
      songString += section.duration;

      section.chords!.forEach((chord) {
        songString += chord.name;

        if (chord.modifications != null) songString += chord.modifications!;

        songString += chord.beats;

        if (chord.bass != null) songString += chord.bass!;
      });

      section.lyrics!.forEach((lyric) {
        songString += lyric.text;
        songString += lyric.timestamp;
      });
    });

    logger.d('Song string: $songString');

    final bytes = utf8.encode(songString);
    final hash = sha256.convert(bytes);

    logger.d('Hashed song: ${hash.toString()}');

    return hash.toString();
  }
}
