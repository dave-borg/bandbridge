// import 'dart:io' as io;

import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
    logger.i("allSongs: Getting all songs");

    final db = await Hive.openBox('songs');
    logger.d("allSongs: Database opened\nIs Empty: ${db.isEmpty}");

    List<Song> songs = [];

    logger.d('allSongs: ${db.length} songs found at load');

    if (db.isEmpty) {
      logger.d("allSongs: No songs found, loading sample songs.");
      songs = await loadSampleSongs();

      logger.d("allSongs: Saving sample songs to database.");
      for (var song in songs) {
        logger.d("allSongs: Saving sample song: ${song.title}");
        await db.put(song.id, song.toJson());
      }
    }
    logger.d(
        'allSongs: ${db.length} songs found, loading previously saved songs.');

    for (var i = 0; i < db.length; i++) {
      var song = db.getAt(i);

      Map<String, dynamic> songMap = Map<String, dynamic>.from(song as Map);
      Song loadedSong = Song.fromJson(songMap);
      songs.add(loadedSong);

      logger.d(loadedSong.getDebugOutput("Loaded song from database"));
    }

    logger.d("allSongs: Returning ${songs.length} songs.");

    return songs;
  }

  void addSong(Song song) {
    songs.add(song);
  }

  Future<List<Song>> loadSampleSongs() async {
    var logger = Logger(level: LoggingUtil.loggingLevel('SongsService'));
    logger.i("loadSampleSongs: Getting all songs");

    List<String> songFiles = [
      'assets/songs/baker-street_43f34fofj34oif3.json',
      'assets/songs/seven-nation-army-fgsdjhb1345jb.json',
      'assets/songs/hotel-california_asfa8g7dfsgs.json',
      'assets/songs/imagine_dfsvd7sfvsdfhv.json',
      'assets/songs/down-under_sdfgs786g8df.json',
    ];

    for (var file in songFiles) {
      String jsonString = await rootBundle.loadString(file);

      logger.d("loadSampleSongs: Loaded JSON file: $file");
      logger.t("loadSampleSongs: JSON data: $jsonString");

      if (jsonDecode(jsonString) != null) {
        try {
          logger.t('Parsing JSON file: $file');
          Map<String, dynamic> songData = jsonDecode(jsonString);
          Song song = Song.fromJson(songData);
          songs.add(song);
        } catch (e, stacktrace) {
          logger.e(
              'Error parsing JSON file: $file\n${e.toString()}\n$stacktrace');
        }
      } else {
        logger.e('Failed to load JSON file: $file');
      }
      logger.d('Number of songs: ${songs.length}');
    }

    //saveSongs();
    return songs;
  }

  void outputSongDatabaseContents() async {
    var logger = Logger(level: LoggingUtil.loggingLevel('SongsService'));
    logger.d('Outputting song database contents');

    final db = await Hive.openBox('songs');
    for (var key in db.keys) {
      logger.d('Key: $key \nValue: ${jsonEncode(db.get(key))}\n==========');
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
      saveSong(song);
    }
  }

  /// Saves the given [thisSong] to the 'songs' box in Hive.
  ///
  /// This method opens the 'songs' box using Hive and saves the [thisSong] object
  /// with its ID as the key.
  ///
  /// Example usage:
  /// ```dart
  /// Song song = Song(id: 1, title: 'My Song');
  /// await saveSong(song);
  /// ```
  static Future<void> saveSong(Song thisSong) async {
    Box box;

    if (Hive.isBoxOpen('songs')) {
      box = Hive.box('songs');
    } else {
      box = await Hive.openBox('songs');
    }

    await box.put(thisSong.id, thisSong.toJson());
  }
}
