// import 'dart:io' as io;

import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
// imp:path/path.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/mdl_song.dart';

import 'dart:convert';

class SongsService {
  static final SongsService _singleton = SongsService._internal();

  factory SongsService() {
    return _singleton;
  }

  SongsService._internal();

  List<Song> songs = [];

  Future<List<Song>> get allSongs async {
    var logger = Logger(level: LoggingUtil.loggingLevel('SongsService'));
    logger.i("Getting all songs");

    final db = await _getDatabase();

    List<Song> songs = [];

    if (db.length == 0) {
      logger.d("No songs found, loading sample songs.");
      songs = await loadSampleSongs();
    } else {
      logger.d('${db.length} songs found, loading previously saved songs.');
      for (var i = 0; i < db.length; i++) {
        var song = db.getAt(i);

        logger.d("Loading song from Hive $song");

        Map<String, dynamic> songMap = Map<String, dynamic>.from(song);
        songs.add(Song.fromJson(songMap));
      }
    }

    logger.d("Returning ${songs.length} songs.");

    return songs;
  }

  void addSong(Song song) {
    songs.add(song);
  }

  Future<List<Song>> loadSampleSongs() async {
    var logger = Logger(level: LoggingUtil.loggingLevel('SongsService'));
    logger.i("Getting all songs");

    List<String> songFiles = [
      'assets/songs/baker-street_43f34fofj34oif3.json',
      'assets/songs/seven-nation-army-fgsdjhb1345jb.json',
      'assets/songs/hotel-california_asfa8g7dfsgs.json',
      'assets/songs/imagine_dfsvd7sfvsdfhv.json',
      'assets/songs/down-under_sdfgs786g8df.json',
    ];

    for (var file in songFiles) {
      String jsonString = await rootBundle.loadString(file);

      logger.d("Loaded JSON file: $file");
      logger.t("JSON data: $jsonString");

      if (jsonDecode(jsonString) != null) {
        try {
          Map<String, dynamic> songData = jsonDecode(jsonString);
          Song song = Song.fromJson(songData);
          songs.add(song);
        } catch (e) {
          logger.e('Error parsing JSON file: $file');
          logger.e(e);
        }
      } else {
        logger.e('Failed to load JSON file: $file');
      }
      logger.d('Number of songs: ${songs.length}');
    }

    //saveSongs();
    return songs;
  }

  /// Saves the songs to shared preferences.
  /// This method encodes the songs into JSON format and stores them in the 'songs' key of shared preferences.
  /// It's like putting the songs in a tiny bottle and throwing them into the vast ocean of shared preferences.
  /// May the songs find their way back to you when you need them the most.
  Future<void> saveSongs() async {
    var logger = Logger(level: LoggingUtil.loggingLevel('SongsService'));
    int count = 0;

    final db = await _getDatabase();

    logger.d('Saving ${songs.length} songs to database.');

    var uuid = const Uuid();

    for (var song in songs) {
      if (song.id == "-1") {
        String id;
        do {
          id = uuid.v4();
        } while (db.containsKey(id));
        song.id = id;
      }

      logger.d("Saving song: ${song.id.toString()}");
      await db.put(song.id, song.toJson());
      count++;
    }

    outputSongDatabaseContents();
    count = 0;
  }

  _getDatabase() async {
    var db = await Hive.openBox('songs');
    return db;
  }

  void outputSongDatabaseContents() async {
    var logger = Logger(level: LoggingUtil.loggingLevel('SongsService'));
    logger.d('Outputting song database contents');

    final db = await Hive.openBox('songs');
    for (var key in db.keys) {
      logger.d('Key: $key \nValue: ${jsonEncode(db.get(key))}\n==========');
    }
  }
}
