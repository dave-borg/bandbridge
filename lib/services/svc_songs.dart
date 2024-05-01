import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/mdl_song.dart';

class SongsService {
  SongsService();

  Future<List<Song>> get allSongs async {
    List<String> songFiles = [
      'assets/songs/baker-street_43f34fofj34oif3.json',
      'assets/songs/seven-nation-army-fgsdjhb1345jb.json',
      // Add more song files here
    ];
    List<Song> songs = [];

    try {
      for (String filePath in songFiles) {
        String jsonString = await rootBundle.loadString(filePath);
        Map<String, dynamic> songJson = jsonDecode(jsonString);
        songs.add(Song.fromJson(songJson));
      }
    } catch (e) {
      // Handle the error here
      print('Error loading songs: $e');
    }

    return songs;
  }
}
