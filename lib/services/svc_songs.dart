import 'package:bandbridge/utils/logging_util.dart';
import 'package:logger/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/mdl_song.dart';

class SongsService {
  static final SongsService _singleton = SongsService._internal();

  factory SongsService() {
    return _singleton;
  }

  SongsService._internal();

  List<Song> songs = [];

  void addSong(Song song) {
    songs.add(song);
  }

  void outputSongDatabaseContents() async {
    var logger = Logger(level: LoggingUtil.loggingLevel('SongsService'));
    logger.d('Outputting song database contents');

    final db = Hive.box<Song>('songs');

    var allSongs = db.values.toList();
    for (var thisSong in allSongs) {
      logger.d('${thisSong.toJson()}\n==========');
    }
  }

  /// Saves all the songs in the provided list.
  ///
  /// This method takes a list of [Song] objects and saves each song individually
  /// by calling the [saveSong] method. It performs the saving operation
  /// asynchronously using the `async` and `await` keywords.
  ///
  /// Example usage:
  /// ```dart
  /// List<Song> allSongs = [...];
  /// await saveAllSongs(allSongs);
  /// ```
  static Future<void> saveAllSongs(List<Song> allSongs) async {
    for (var song in allSongs) {
      song.save();
    }
  }
}
