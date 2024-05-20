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
  SongsService();

  List<Song> songs = [];

  Future<List<Song>> get allSongs async {
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
      logger.d("JSON data: $jsonString");

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
    return songs;
  }

  void addSong(Song song) {
    songs.add(song);
  }

  /// Saves the songs to shared preferences.
  /// This method encodes the songs into JSON format and stores them in the 'songs' key of shared preferences.
  /// It's like putting the songs in a tiny bottle and throwing them into the vast ocean of shared preferences.
  /// May the songs find their way back to you when you need them the most.
  Future<void> saveSongs() async {
  final db = await _getDatabase();
  for (var song in songs) {
    if (song.id != null) {
      // If the song has an id, update the existing song.
      await db.update('Songs', song.toJson(), where: 'id = ?', whereArgs: [song.id]);
    } else {
      // If the song doesn't have an id, insert a new song.
      await db.insert('Songs', song.toJson());
    }
  }
}

  /// Loads the songs from shared preferences.
  /// This method retrieves the songs stored in the 'songs' key of shared preferences and decodes them from JSON format.
  /// It's like searching the vast ocean of shared preferences for the tiny bottles containing the songs.
  /// May the songs be found and brought back to life, ready to be played once again.
  Future<void> loadSongs() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('Songs');

    songs = List.generate(maps.length, (i) {
      return Song(
        id: maps[i]['id'],
        title: maps[i]['title'],
        artist: maps[i]['artist'],
        initialKey: maps[i]['initialKey'],
        tempo: maps[i]['tempo'],
        timeSignature: maps[i]['timeSignature'],
      );
    });
  }

  Future<Database> _getDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'songs.db');
    return openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Songs (title TEXT, artist TEXT, initialKey TEXT, tempo TEXT, timeSignature TEXT)');
    });
  }
}
