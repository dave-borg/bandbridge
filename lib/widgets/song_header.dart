import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SongHeader extends StatelessWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('SongArrangementPanel'));
  
  Song song;

  SongHeader({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
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
                                  song.title,
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // Handle button press
                                  },
                                ),
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
                                  song.artist,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
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
                                    song.timeSignature,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
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
                                        song.tempo,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                      song.tempo.isEmpty
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
                                    song.initialKey,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
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
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  shadowColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  surfaceTintColor: MaterialStateProperty.all(
                                      Colors.transparent),
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