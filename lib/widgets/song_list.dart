import 'package:flutter/material.dart';

import '../services/svc_songs.dart';

class SongList extends StatelessWidget {
  SongList({super.key});

  SongsService songsService = SongsService();

  @override
  build(BuildContext context) async {
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
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: await songsService.allSongs.then((list) {
                return list.map((song) {
                  return SizedBox(
                    height: 40,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(song.title),
                    ),
                  );
                }).toList();
              }),
            ),
          ),
        ]),
      ),
    );
  }
}
