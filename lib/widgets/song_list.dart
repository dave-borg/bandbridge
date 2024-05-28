import 'package:bandbridge/models/current_song.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/songs/song_header_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// Here's our SongList, the rockstar of our app!
class SongList extends StatefulWidget {
  SongList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  var logger = Logger(level: LoggingUtil.loggingLevel('SongList'));

  late Future<List<Song>> allSongsFuture = Future.value([]);
  final TextEditingController _searchController = TextEditingController();
  List<Song> _filteredSongs = [];
  List<Song> _allSongs = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadAllSongs();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _loadAllSongs();
  // }

  void _loadAllSongs() async {
    var currentSongProvider =
        Provider.of<CurrentSongProvider>(context, listen: false);
    List<Song> songs = await currentSongProvider.getAllSongs;
    setState(() {
      _allSongs = songs;
    });
  }

  @override
  build(BuildContext context) {
    logger.d('Building the SongList widget.');

    var currentSongProvider = Provider.of<CurrentSongProvider>(context);
    _loadAllSongs();

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
                  logger.d("Sort songs button pressed!!!");
                },
              ),

              //================================================================================================
              // Add a Song btn
              // This is the button that adds a new song to our list
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SongHeaderDialog(
                        dialogTitle: 'Add Song',
                        onSongCreated: (newSong) {
                          setState(() {
                            currentSongProvider.saveSong(newSong);
                            _loadAllSongs();
                            _filteredSongs = _allSongs;
                          });
                        },
                      );
                    },
                  );
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
            child: Consumer<CurrentSongProvider>(
              builder: (context, currentSongProvider, child) {
                logger.d('allSongsFuture.length: ${allSongsFuture.toString()}');

                return FutureBuilder<List<Song>>(
                  future: currentSongProvider.getAllSongs,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      logger.d("Waiting for songs.");
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      logger.e("Error fetching songs: ${snapshot.error}");
                      return const Text("Error fetching songs");
                    } else if (snapshot.hasData) {
                      logger.d("Got songs. Data: ${snapshot.data?.length}");

                      // If we haven't set _allSongs yet, set it to the snapshot data - should only happen on the first run
                      // if (_allSongs.isEmpty) {
                      //   logger.d('allSongs is empty');
                      _allSongs = snapshot.data!;
                      _filteredSongs = _allSongs;

                      Logger(level: LoggingUtil.loggingLevel('SongList')).d(
                          'Songs read in from snapshot\n${_allSongs.map((song) => song.getDebugOutput()).join('\n')}');
                      // }

                      Logger(level: LoggingUtil.loggingLevel('SongList')).d(
                          'Songs in _filteredSongs\n${_filteredSongs.map((song) => song.getDebugOutput()).join('\n')}');

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
                  },
                );
              },
            ),
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

    return Consumer<CurrentSongProvider>(
        builder: (context, currentSongProvider, child) {
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
                  child: TextButton(
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
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
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
}
