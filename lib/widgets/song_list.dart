import 'package:bandbridge/models/song_provider.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/songs/song_header_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// A widget that displays a list of songs.
///
/// This widget is the rockstar of our app! It is responsible for rendering a list of songs
/// and providing a user interface for selecting the current song, and access CRUD functionality.
/// The SongList widget is a stateful widget, as it needs to maintain the state of the currently
/// selected song and the list of songs to display.
/// The SongList widget is also a consumer of the CurrentSongProvider, which provides the current
/// song and the list of all songs.
class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  var logger = Logger(level: LoggingUtil.loggingLevel('SongList'));
  late SongProvider currentSongProvider;

  late Future<List<Song>> allSongsFuture = Future.value([]);
  final TextEditingController _searchController = TextEditingController();
  List<Song> _filteredSongs = [];
  List<Song> _allSongs = [];

  @override
  void initState() {
    super.initState();
    _updateAllSongs();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateAllSongs();
    currentSongProvider = Provider.of<SongProvider>(context);
  }

  @override
  build(BuildContext context) {
    logger.d('Building the SongList widget.');

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

              //================================================================================================
              // Sort btn
              // Change the sort order of the song list
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
                key: const Key('btn_songList_addSong'),
                icon: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ChangeNotifierProvider<SongProvider>.value(
                        value: currentSongProvider,
                        child: SongHeaderDialog(
                          key: const Key('dlg_songList_songHeaderDialog'),
                          dialogTitle: 'Add Song',
                          song: Song(
                            songId: "-2",
                            title: "",
                            artist: "",
                            initialKey: "C",
                            timeSignature: "4/4",
                            tempo: "120",
                          ),
                          onSongCreated: (newSong) {
                            setState(() {
                              // currentSongProvider.saveSong(newSong);
                              // _filteredSongs = _allSongs;

                              logger
                                  .d(newSong.getDebugOutput("Adding new song"));

                              _addSong(newSong);
                              _updateAllSongs();
                              currentSongProvider.setCurrentSong(newSong);
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),

          //================================================================================================
          // Our search box, the key to finding your favorite tunes
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              height: 45.0,
              alignment: Alignment.center,
              child: Center(
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
          ),

          //chaning the FutureBuilder to ValueListenableBuilder
          Expanded(
            child: ValueListenableBuilder<Box<Song>>(
              valueListenable: Hive.box<Song>('songs').listenable(),
              builder: (context, Box<Song> box, widget) {
                logger.d(
                    'allSongs selected from the database: ${_filteredSongs.length}');

                if (_filteredSongs.isEmpty) {
                  logger.d("No songs available.");
                  return const Text("No songs available");
                } else {
                  logger.d("Got songs. Data: ${_filteredSongs.length}");

                  Logger(level: LoggingUtil.loggingLevel('SongList')).d(
                      'ValueListenableBuilder: Songs in _filteredSongs\n${_filteredSongs.map((song) => song.getDebugOutput()).join('\n')}');

                  if (_filteredSongs.isEmpty) {
                    return const Text("No songs found");
                  } else {
                    return buildSongs(_filteredSongs);
                  }
                }
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

    return Consumer<SongProvider>(
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
                    key: Key('songList_btn_title_${thisSong.id}'),
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
        _filteredSongs = List.from(_allSongs);
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

  void _updateAllSongs() async {
    _allSongs = Hive.box<Song>('songs').values.toList();
    setState(() {
      _filteredSongs = List.from(_allSongs);
    });
  }

  void _addSong(Song song) {
    Hive.box<Song>('songs').add(song);
  }
}
