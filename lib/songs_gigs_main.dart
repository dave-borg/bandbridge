import 'package:bandbridge/models/song_provider.dart';
import 'package:bandbridge/utils/song_generator.dart';
import 'package:bandbridge/widgets/song_view_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/gig_list.dart';
import 'widgets/song_list.dart';

class SongsGigsMain extends StatelessWidget {
  const SongsGigsMain({super.key});

  @override
  Widget build(BuildContext context) {
    const isTestSong = bool.fromEnvironment('test-song', defaultValue: false);
    if (isTestSong) {
      // Run with the following command to add a completed song into the database:
      // flutter run --dart-define=test-song=true
      SongGenerator.createTestSong();
    }

    return Scaffold(
      body: Consumer<SongProvider>(builder: (context, songProvider, _) {
        var _currentSong = songProvider.currentSong;
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  // Song List
                  const SongList(),
                  // Gig List
                  GigList(),
                ],
              ),
            ),
            Expanded(
              child: _currentSong.id != "-2"
                  ? Container(
                      margin: const EdgeInsets.only(
                          left: 0, top: 6, right: 0, bottom: 6),
                      decoration: BoxDecoration(
                        color: Colors.white, // Your desired color
                        borderRadius: BorderRadius.circular(9.0),
                        border: Border.all(
                          color: const Color.fromRGBO(
                              203, 203, 203, 1.0), // Your desired border color
                          width: 1.0, // Your desired border width
                        ),
                      ),
                      child: const SongViewPanel(),
                    )
                  : const SizedBox(
                      width: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Welcome to BandBridge!",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}
