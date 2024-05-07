import 'package:bandbridge/models/current_song.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/services/songs_hasher.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../services/svc_songs.dart';

// Here's our SongList, the rockstar of our app!
class SongList extends StatefulWidget {
  SongList({super.key});

  // Our trusty song service, always ready to fetch us some tunes
  final SongsService songsService = SongsService();

  @override
  // ignore: library_private_types_in_public_api
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  var logger = Logger(level: LoggingUtil.loggingLevel('SongList'));

  // A future that holds all our songs. It's like a time capsule for music!
  Future<List<Song>> allSongsFuture = getAllSongs();

  final TextEditingController _searchController = TextEditingController();
  List<Song> _filteredSongs = [];
  List<Song> _allSongs = [];

  // A function that gets all songs. It's like a musical treasure hunt!
  static Future<List<Song>> getAllSongs() {
    Logger(level: LoggingUtil.loggingLevel('SongList')).d('Getting all songs.');
    Future<List<Song>> allSongs = SongsService().allSongs;

    return allSongs;
  }

  @override
  build(BuildContext context) {
    logger.d('Building the SongList widget.');
    // Our main stage, where all the action happens
    return Expanded(
      child: Container(
        // Some padding to give our widget room to breathe
        margin: const EdgeInsets.only(right: 6.0, left: 6.0, top: 6.0),
        // A little decoration never hurt anyone
        decoration: BoxDecoration(
          color: Colors.white, // As pure as a new guitar string
          borderRadius: BorderRadius.circular(9.0), // Smooth as a jazz solo
          border: Border.all(
            color: const Color.fromRGBO(
                203, 203, 203, 1.0), // A border as solid as a drum beat
            width: 1.0, // Just the right thickness
          ),
        ),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Songs',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              ),
              // A button that does... something. It's a mystery!
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () {
                  logger.d("Sort songs button pressed.");
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Handle button press
                  logger.d("Add song button pressed.");
                },
              )
            ],
          ),

          // Our search box, the key to finding your favorite tunes
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              height: 45.0,
              alignment: Alignment.center,
              child: TextField(
                controller: _searchController,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      logger.d("Clear search button pressed.");
                      _searchController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
            ),
          ),

          // The heart of our app, the song list
          Expanded(
            child: FutureBuilder<List<Song>>(
                future: allSongsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    logger.d("Waiting for songs.");
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    logger.d("Got songs.");

                    // If we haven't set _allSongs yet, set it to the snapshot data - should only happen on the first run
                    if (_allSongs.isEmpty) {
                      _allSongs = snapshot.data!;
                      _filteredSongs = _allSongs;
                    }

                    // If we have songs, build the song list
                    if (_filteredSongs.isEmpty) {
                      return const Text("No songs found");

                      // If we have no songs show a message
                    } else {
                      return buildSongs(_filteredSongs);
                    }
                  } else {
                    logger.d("No songs available.");
                    return const Text("No data available");
                  }
                }),
          ),
        ]),
      ),
    );
  }

  State<StatefulWidget> createState() {
    return _SongListState();
  }

  // A function to build our song list. It's like a concert promoter for our app!
  Widget buildSongs(List<Song> filteredSongs) {
    logger.d("Building the song list with ${filteredSongs.length} songs.");

    return ListView.builder(
      itemCount: filteredSongs.length,
      itemBuilder: (context, index) {
        final thisSong = filteredSongs[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Consumer<CurrentSongProvider>(
                    builder: (context, currentSongProvider, child) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: currentSongProvider.currentSong.title ==
                              thisSong.title
                          ? const Color.fromARGB(255, 237, 243, 248)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      logger.d('Song selected: ${thisSong.title}');
                      logger.d(
                          'Current song hash: ${SongHasher.hashSong(currentSongProvider.currentSong)}');
                      currentSongProvider.setCurrentSong(thisSong);
                    },
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              thisSong.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(thisSong.artist),
                          ],
                        )),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  _onSearchChanged() {
    logger.d("Search text: ${_searchController.text}");
    if (_searchController.text.isEmpty || _searchController.text.length < 3) {
      logger.d("No search phrase - _allSongs: $_allSongs");
      setState(() {
        _filteredSongs = _allSongs;
      });
    } else {
      logger.d("Filtering songs - ${_searchController.text}");
      setState(() {
        _filteredSongs = _allSongs
            .where((song) =>
                song.title
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) ||
                song.artist
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()))
            .toList();
      });
      for (var song in _filteredSongs) {
        logger.d('Filtered song title: ${song.title}');
      }
      logger.d("Filtered songs: ${_filteredSongs.length}");
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }
}
