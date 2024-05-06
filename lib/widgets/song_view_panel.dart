import 'package:bandbridge/models/current_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
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
    final List<String> arrangement = [
      'Intro',
      'Verse',
      'Chorus',
      'Verse',
      'Chorus',
      'Bridge',
      'Chorus',
      'Outro',
    ];

    // ignore: no_leading_underscores_for_local_identifiers
    var _currentSong = context.watch<CurrentSongProvider>();

    logger.d('SongViewPanel rebuilt with song: ${_currentSong.title} by ${_currentSong.artist}');

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //====================
        //====================
        // Song header panel

        SizedBox(
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
                                  _currentSong.title,
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
                                  _currentSong.artist,
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
                                    _currentSong.timeSignature,
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
                                        _currentSong.tempo,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                      _currentSong.tempo.isEmpty
                                        ? SizedBox.shrink()
                                        : Text(
                                            'BPM',
                                            style: Theme.of(context).textTheme.bodyLarge,
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
                                    _currentSong.initialKey,
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
        ),

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
                            children: arrangement.map((section) {
                              return SizedBox(
                                height: 40,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(section),
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