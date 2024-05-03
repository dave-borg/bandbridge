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

    // try {
    //   for (String filePath in songFiles) {
    //     String jsonString = await rootBundle.loadString(filePath);
    //     Map<String, dynamic> songJson = jsonDecode(jsonString);
    //     songs.add(Song.fromJson(songJson));
    //   }
    // } catch (e) {
    //   // Handle the error here
    //   print('Error loading songs: $e');
    // }

    songs = [
      Song(
        title: 'Baker Street',
        artist: 'Gerry Rafferty',
        duration: "270", 
        timeSignature: '4/4', 
        structure: [

        ],
        versions: [],
      ),
      Song(
        title: 'Seven Nation Army',
        artist: 'The White Stripes',
        duration: "231",
        timeSignature: '4/4',
        structure: [],
        versions: [],
      ),
      Song(
        title: 'Crazy',
        artist: 'Gnarl Barkley',
        duration: "324",
        timeSignature: '4/4',
        structure: [],
        versions: [],
      ),
      Song(
        title: 'Beautiful Day',
        artist: 'U2',
        duration: "422",
        timeSignature: '4/4',
        structure: [],
        versions: [],
      ),
      // Add more songs here
    ];

    logger.i('Number of songs: ${songs.length}');

    return Future.value(songs);
  }
}
