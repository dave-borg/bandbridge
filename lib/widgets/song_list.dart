import 'package:bandbridge/models/current_song.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../services/svc_songs.dart';

class SongList extends StatefulWidget {
  SongList({super.key});

  final SongsService songsService = SongsService();

  @override
  // ignore: library_private_types_in_public_api
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  var logger = Logger();

  Future<List<Song>> allSongsFuture = getAllSongs();

  static Future<List<Song>> getAllSongs() {
    Logger().d('Getting all songs.');
    Future<List<Song>> _allSongs = SongsService().allSongs;



    return _allSongs;

  }

  @override
  build(BuildContext context) {
    logger.d('Building the SongList widget.');
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 6.0, left: 6.0, top: 6.0),
        decoration: BoxDecoration(
          color: Colors.white, // Your desired color
          borderRadius: BorderRadius.circular(9.0),
          border: Border.all(
            color: const Color.fromRGBO(
                203, 203, 203, 1.0), // Your desired border color
            width: 1.0, // Your desired border width
          ), // Your desired corner radius
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
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () {
                  // Handle button press
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Handle button press
                },
              )
            ],
          ),

          //========================
          // Search Box

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 35.0,
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.clear),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
            ),
          ),

          //========================
          // Song List

          Expanded(
            child: FutureBuilder<List<Song>>(
                future: allSongsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    final posts = snapshot.data!;
                    return buildSongs(posts);
                  } else {
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

  Widget buildSongs(List<Song> songs) {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final thisSong = songs[index];
        return Container(
          //color: Colors.grey.shade300,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          //height: 100,
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Consumer<CurrentSongProvider>(
                    builder: (context, currentSongProvider, child) {
                  return TextButton(
                    onPressed: () {
                      logger.d('Song selected: ${thisSong.title}');
                      currentSongProvider.setCurrentSong(thisSong);
                    },
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('${thisSong.title} - ${thisSong.artist}')),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
