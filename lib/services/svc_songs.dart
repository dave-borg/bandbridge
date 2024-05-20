import 'dart:io' as io;

import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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

    // List<String> songFiles = [
    //   'assets/songs/baker-street_43f34fofj34oif3.json',
    //   'assets/songs/seven-nation-army-fgsdjhb1345jb.json',
    //   'assets/songs/hotel-california_asfa8g7dfsgs.json',
    //   'assets/songs/imagine_dfsvd7sfvsdfhv.json',
    //   'assets/songs/down-under_sdfgs786g8df.json',
    // ];

    // for (var file in songFiles) {
    //   String jsonString = await rootBundle.loadString(file);

    //   logger.d("Loaded JSON file: $file");
    //   logger.d("JSON data: $jsonString");

    //   if (jsonDecode(jsonString) != null) {
    //     try {
    //       Map<String, dynamic> songData = jsonDecode(jsonString);
    //       Song song = Song.fromJson(songData);
    //       songs.add(song);
    //     } catch (e) {
    //       logger.e('Error parsing JSON file: $file');
    //       logger.e(e);
    //     }
    //   } else {
    //     logger.e('Failed to load JSON file: $file');
    //   }
    //   logger.d('Number of songs: ${songs.length}');
    // }

    return loadSongs();
  }

  void addSong(Song song) {
    songs.add(song);
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

    try {
      // await db.transaction((txn) async {
      for (var song in songs) {
        var songJson = song.toJson();
        songJson.remove('structure');
        songJson.remove('versions');

        logger.d('$count songs saved so far.');

        if (song.id != null) {
          logger.d('Updating song: $songJson');

          // If the song has an id, update the existing song.
          int result = await db
              .update('Songs', songJson, where: 'id = ?', whereArgs: [song.id]);

          logger.d('Update result: $result');
          count = count + result;
        } else {
          logger.d('Inserting song: $songJson');
          // If the song doesn't have an id, insert a new song.
          int result = count += await db.insert('Songs', songJson);
          logger.d('Insert result: $result');
          count = count + result;
        }
      }
      // });
      logger.d('Transaction successful. Saved $count songs to database.');
    } catch (e) {
      logger.e('Transaction rolled back due to error: $e');
    }
    logger.d('Saved $count songs to database.');
    count = 0;
  }

  /// Loads the songs from shared preferences.
  /// This method retrieves the songs stored in the 'songs' key of shared preferences and decodes them from JSON format.
  /// It's like searching the vast ocean of shared preferences for the tiny bottles containing the songs.
  /// May the songs be found and brought back to life, ready to be played once again.
  Future<List<Song>> loadSongs() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('Songs');

    songs = List.generate(maps.length, (i) {
      return Song(
        id: maps[i]['id'],
        title: maps[i]['title'],
        artist: maps[i]['artist'],
        duration: maps[i]['duration'],
        initialKey: maps[i]['initialKey'],
        tempo: maps[i]['tempo'],
        timeSignature: maps[i]['timeSignature'],
      );
    });

    return songs;
  }

  Future<Database> _getDatabase() async {
    var logger = Logger(level: LoggingUtil.loggingLevel('SongsService'));
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'bandbridge.db');
    logger.d('Opening database at $path');
    return openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Songs (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, artist TEXT, duration TEXT, initialKey TEXT, tempo TEXT, timeSignature TEXT)');
      await db.execute(
          'CREATE TABLE Structure (id INTEGER PRIMARY KEY AUTOINCREMENT, songId INTEGER, section TEXT, timestamp TEXT, duration TEXT, FOREIGN KEY(songId) REFERENCES Songs(id))');
      await db.execute(
          'CREATE TABLE Chords (id INTEGER PRIMARY KEY AUTOINCREMENT, structureId INTEGER, name TEXT, beats TEXT, FOREIGN KEY(structureId) REFERENCES Structure(id))');
      await db.execute(
          'CREATE TABLE Lyrics (id INTEGER PRIMARY KEY AUTOINCREMENT, structureId INTEGER, text TEXT, timestamp TEXT, FOREIGN KEY(structureId) REFERENCES Structure(id))');
    });
  }
}
