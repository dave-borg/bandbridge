import 'package:bandbridge/models/current_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/song_header.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class SongViewPanel extends StatefulWidget {
  const SongViewPanel({super.key});

  @override
  State<StatefulWidget> createState() => _SongViewPanelState();
}

class _SongViewPanelState extends State<SongViewPanel> {
  var logger = Logger(level: LoggingUtil.loggingLevel('SongViewPanel'));

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    var currentSong = context.watch<CurrentSongProvider>();

    logger.d(
        'SongViewPanel rebuilt with song: ${currentSong.title} by ${currentSong.artist}');

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //====================
        //====================
        // Song header panel

        SongHeader(song: currentSong.currentSong),

        //====================
        //====================
        // Song panel with arrangement and chart

        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 130,
                child: Column(
                  children: [
                    // Toolbar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 30.0, // Your desired width
                          child: IconButton(
                            padding: EdgeInsets.zero, // Remove padding
                            icon: const Icon(Icons.add,
                                size: 20.0), // Set icon size
                            onPressed: () {
                              // Handle add button press
                            },
                          ),
                        ),
                        SizedBox(
                          width: 30.0, // Your desired width
                          child: IconButton(
                            padding: EdgeInsets.zero, // Remove padding
                            icon: const Icon(Icons.edit,
                                size: 20.0), // Set icon size
                            onPressed: () {
                              // Handle add button press
                            },
                          ),
                        ),
                        SizedBox(
                          width: 30.0, // Your desired width
                          child: IconButton(
                            padding: EdgeInsets.zero, // Remove padding
                            icon: const Icon(Icons.content_copy,
                                size: 20.0), // Set icon size
                            onPressed: () {
                              // Handle add button press
                            },
                          ),
                        ),
                      ],
                    ),
                    // ListView
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(8),
                        children: <Widget>[
                          Column(
                            children: (currentSong.structure as List)
                                .map((arrangementItem) {
                              return SizedBox(
                                height: 40,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(arrangementItem.section),
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 40,
                        width: 140,
                        child: const Text('Intro',
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Myriad Pro',
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(5.0),
                        height: 80,
                        width: 140,
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Colors
                                  .black, // Change this color to the one you prefer
                              width:
                                  3.0, // Change this value to the one you prefer
                            ),
                          ),
                        ),
                        child: RichText(
                          text: const TextSpan(
                            text: 'C\u266F',
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Myriad Pro',
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'm',
                                style: TextStyle(
                                  fontSize: 20,
                                  // 75% of the original size
                                  //baseline: TextBaseline.alphabetic,
                                  textBaseline: TextBaseline.alphabetic,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(5.0),
                        height: 80,
                        width: 140,
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Colors
                                  .black, // Change this color to the one you prefer
                              width:
                                  3.0, // Change this value to the one you prefer
                            ),
                          ),
                        ),
                        child: RichText(
                          text: const TextSpan(
                            text: 'A',
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Myriad Pro',
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(5.0),
                        height: 80,
                        width: 140,
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Colors
                                  .black, // Change this color to the one you prefer
                              width:
                                  3.0, // Change this value to the one you prefer
                            ),
                          ),
                        ),
                        child: RichText(
                          text: const TextSpan(
                            text: 'G\u266F',
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Myriad Pro',
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(5.0),
                        height: 80,
                        width: 140,
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Colors
                                  .black, // Change this color to the one you prefer
                              width:
                                  3.0, // Change this value to the one you prefer
                            ),
                            right: BorderSide(
                              color: Colors
                                  .black, // Change this color to the one you prefer
                              width:
                                  3.0, // Change this value to the one you prefer
                            ),
                          ),
                        ),
                        child: RichText(
                          text: const TextSpan(
                            text: 'G\u266F',
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Myriad Pro',
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
