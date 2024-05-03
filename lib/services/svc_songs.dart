import 'package:logger/logger.dart';

import '../models/mdl_song.dart';

class SongsService {
  SongsService();

  Future<List<Song>> get allSongs {
    var logger = Logger();
    
    // List<String> songFiles = [
    //   'assets/songs/baker-street_43f34fofj34oif3.json',
    //   'assets/songs/seven-nation-army-fgsdjhb1345jb.json',
    //   // Add more song files here
    // ];
    List<Song> songs = [];

    songs = [
      Song(
        title: 'Baker Street',
        artist: 'Gerry Rafferty',
        duration: "270", 
        timeSignature: '41/4',
        tempo: "114",
        initialKey: "Gmaj",
        structure: [

        ],
        versions: [],
      ),
      Song(
        title: 'Seven Nation Army',
        artist: 'The White Stripes',
        duration: "231",
        timeSignature: '42/4',
        tempo: "124",
        initialKey: "Cmin",
        structure: [],
        versions: [],
      ),
      Song(
        title: 'Crazy',
        artist: 'Gnarl Barkley',
        duration: "324",
        timeSignature: '43/4',
        tempo: "114",
        initialKey: "Gmaj",
        structure: [],
        versions: [],
      ),
      Song(
        title: 'Beautiful Day',
        artist: 'U2',
        duration: "422",
        timeSignature: '44/4',
        tempo: "114",
        initialKey: "Gmaj",
        structure: [],
        versions: [],
      ),
      // Add more songs here
    ];

    logger.d('Number of songs: ${songs.length}');

    return Future.value(songs);
  }
}
