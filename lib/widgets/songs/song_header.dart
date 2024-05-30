import 'package:bandbridge/models/current_song.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/songs/song_header_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SongHeader extends StatefulWidget {
  Song? song;

  SongHeader({
    super.key,
  });

  @override
  _SongHeaderState createState() => _SongHeaderState();
}

class _SongHeaderState extends State<SongHeader> {
  var logger = Logger(level: LoggingUtil.loggingLevel('SongHeader'));

  @override
  Widget build(BuildContext context) {
    var currentSongProvider = context.watch<CurrentSongProvider>();
    var currentSong = currentSongProvider.currentSong;
    Song? boxSong;

    var box = Hive.box<Song>('songs');
    if (box.get(currentSong.id) == null || currentSong.id != "-2") {
      logger.d(currentSong.getDebugOutput('build: Song does not exist in box'));
      box.put(currentSong.id, currentSong);
    }

    boxSong = box.get(currentSong.id);

    if (boxSong == null) {
      logger.wtf(
          'Failed to load song from box\nWe shouldn\'t be showing the song panels without a valid song\n\n ${currentSong.getDebugOutput()}');
      throw Exception('Failed to load song from box');
    }

    return SizedBox(
      height: 150,
      width: MediaQuery.of(context).size.width - 258,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 8.0, right: 8.0, bottom: 2.0),
                        child: Row(
                          children: [
                            Text(
                              currentSong.title,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),

                            //================================================================
                            //Edit Button
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SongHeaderDialog(
                                      dialogTitle: 'Edit Song',
                                      song: currentSong,
                                      onSongCreated: (currentSong) {
                                        setState(() {
                                          logger.d(currentSong
                                              .getDebugOutput('Editing Song'));
                                          currentSongProvider
                                              .saveSong(currentSong);
                                        });
                                      },
                                    );
                                  },
                                );
                              },
                            ),

                            //================================================================
                            //Delete button
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm'),
                                      content: Text(
                                          'Are you sure you want to delete \'${boxSong?.title}\'?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('CANCEL'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('DELETE'),
                                          onPressed: () {
                                            boxSong?.delete();
                                            // currentSongProvider
                                            //     .clearSelectedSong();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),

                            //================================================================
                            //Share button
                            IconButton(
                              icon: const Icon(Icons.ios_share),
                              onPressed: () {
                                // Handle button press
                              },
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 0.0, right: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                              currentSong.artist,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0.0, top: 8.0, right: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0,
                                  top: 0.0,
                                  right: 26.0,
                                  bottom: 8.0),
                              child: Text(
                                currentSong.timeSignature,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0,
                                  top: 0.0,
                                  right: 26.0,
                                  bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    currentSong.tempo,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  currentSong.tempo.isEmpty
                                      ? const SizedBox.shrink()
                                      : Text(
                                          'BPM',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0,
                                  top: 0.0,
                                  right: 26.0,
                                  bottom: 8.0),
                              child: Text(
                                currentSong.initialKey,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        // padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle button press
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              surfaceTintColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_arrow, size: 80),
                                Text(
                                  'Play Song',
                                  style: TextStyle(
                                    fontSize:
                                        14.0, // Set this to your desired size
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
