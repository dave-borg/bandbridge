import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import '../models/mdl_song.dart';

import 'dart:convert';

class SongsService {
  SongsService();

  Future<List<Song>> get allSongs async {
    var logger = Logger();

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
          logger.d("Parsing JSON 1");
          Map<String, dynamic> songData = jsonDecode(jsonString);
          logger.d("Parsing JSON 2");
          Song song = Song.fromJson(songData);
          logger.d("Parsing JSON 3");
          songs.add(song);
        } catch (e) {
          logger.e('Error parsing JSON file: $file');
          logger.e(e);
        }
      } else {
        logger.e('Failed to load JSON file: $file');
      }

      // songs = [
      //   Song(
      //     title: 'Baker Street',
      //     artist: 'Gerry Rafferty',
      //     duration: "270",
      //     timeSignature: '41/4',
      //     tempo: "114",
      //     initialKey: "Gmaj",
      //     structure: [
      //     ],
      //     versions: [],
      //   ),
      //   Song(
      //     title: 'Seven Nation Army',
      //     artist: 'The White Stripes',
      //     duration: "231",
      //     timeSignature: '42/4',
      //     tempo: "124",
      //     initialKey: "Cmin",
      //     structure: [],
      //     versions: [],
      //   ),
      //   Song(
      //     title: 'Crazy',
      //     artist: 'Gnarl Barkley',
      //     duration: "324",
      //     timeSignature: '43/4',
      //     tempo: "114",
      //     initialKey: "Gmaj",
      //     structure: [],
      //     versions: [],
      //   ),
      //   Song(
      //     title: 'Beautiful Day',
      //     artist: 'U2',
      //     duration: "422",
      //     timeSignature: '44/4',
      //     tempo: "114",
      //     initialKey: "Gmaj",
      //     structure: [],
      //     versions: [],
      //   ),
      //   // Add more songs here
      // ];
    }
    logger.d('Number of songs: ${songs.length}');

    return songs;
  }
}
