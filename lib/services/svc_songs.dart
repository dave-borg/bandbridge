import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import '../models/mdl_song.dart';

import 'dart:convert';

class SongsService {
  SongsService();

  Future<List<Song>> get allSongs async {
    var logger = Logger(level: LoggingUtil.loggingLevel('SongsService'));
    logger.i("Getting all songs");

    List<String> songFiles = [
      'assets/songs/baker-street_43f34fofj34oif3.json',
      'assets/songs/seven-nation-army-fgsdjhb1345jb.json',
      // Add more song files here
    ];

    List<Song> songs = [];

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
}
