import 'dart:async';

import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/models/song_provider.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/songs/audio/track_player.dart';
import 'package:bandbridge/widgets/songs/lyrics/lyrics_dialog.dart';
import 'package:bandbridge/widgets/songs/lyrics/lyrics_struct.dart';
import 'package:flutter/material.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LyricsEditor extends StatefulWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('LyricsEditor'));
  late TrackPlayer trackPlayer;

  final Song song;
  final int? sectionIndex;
  List<Lyric> lyricsList = [];
  late LyricsStruct previewSections;

  LyricsEditor({super.key, required this.song, this.sectionIndex}) {
    lyricsList = song.unsynchronisedLyrics;
    previewSections = LyricsStruct(song);
    trackPlayer = TrackPlayer(song);
  }

  @override
  // ignore: library_private_types_in_public_api
  _LyricsEditorState createState() => _LyricsEditorState();
}

class _LyricsEditorState extends State<LyricsEditor> {
  var isEditingEnabled = true;
  Timer? timer;
  int thisLyricEndTime = 0;

  @override
  void initState() {
    super.initState();
  }

  startTimer() {
    var diff = 0;
    var previousStartMs = 0;
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      int currentPosition = widget.trackPlayer.getCurrentPosition();

      for (int i = 0; i < widget.previewSections.previewSections.length; i++) {
        var thisSection = widget.previewSections.previewSections[i];

        for (int j = 0; j < thisSection.getLyrics().length; j++) {
          var thisLyric = thisSection.lyrics[j];

          //all other lyrics - check if the start time is before current time
          //and before the start time of the next lyric
          if (j == thisSection.lyrics.length - 1) {
            thisLyricEndTime = thisLyric.calculatedStartTimeMs + diff;
          } else {
            thisLyricEndTime = thisSection.lyrics[j + 1].calculatedStartTimeMs;
            diff = thisLyric.calculatedStartTimeMs - previousStartMs;
          }

          if (currentPosition >= thisLyric.calculatedStartTimeMs &&
              currentPosition <= thisLyricEndTime) {
            setState(() {
              thisLyric.isHighlighted = true;
              widget.logger
                  .d("Highlighing: ${thisLyric.text} @ $currentPosition");
            });
          } else {
            setState(() {
              thisLyric.isHighlighted = false;
            });
          }

          previousStartMs = thisLyric.calculatedStartTimeMs;
        }
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  void clearHighlightedLyrics() {
    for (var thisStructure in widget.previewSections.previewSections) {
      for (var thisLyric in thisStructure.getLyrics()) {
        setState(() {
          thisLyric.isHighlighted = false;
        });
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<PreviewSection> structures =
        widget.previewSections.getPreviewSections();

    for (var thisStructure in structures) {
      thisStructure.thisSection?.scheduleLyrics();
    }

    final songProvider = Provider.of<SongProvider>(context);

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    AppBar(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            children: [
                              //=======================================================
                              //Edit mode button
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor: isEditingEnabled
                                      ? WidgetStateProperty.all(Colors.blue)
                                      : WidgetStateProperty.all(Colors.grey),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isEditingEnabled = !isEditingEnabled;
                                    widget.logger.d(
                                        "Edit button pressed: $isEditingEnabled");
                                  });
                                },
                                child: const Text('Edit Mode'),
                              ),

                              //=======================================================
                              //Lyrics Dialog btn
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () async {
                                  final String? textLyrics =
                                      await showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const LyricsDialog(); // Your custom dialog widget
                                    },
                                  );

                                  // Check if the dialog was dismissed with a result
                                  if (textLyrics != null) {
                                    List<String> lines = textLyrics
                                        .split('\n')
                                        .map((line) => line.trim())
                                        .toList();
                                    List<Lyric> inputLyrics = [];

                                    for (String line in lines) {
                                      if (line.isNotEmpty) {
                                        inputLyrics
                                            .add(Lyric(text: line, beats: ''));
                                      }
                                    }

                                    setState(() {
                                      widget.song.unsynchronisedLyrics =
                                          inputLyrics;
                                      widget.lyricsList = inputLyrics;
                                      widget.logger.d(widget.song
                                          .getDebugOutput(
                                              'Added unsynchronised lyrics'));
                                      songProvider.saveSong(widget.song);
                                      widget.song.save();
                                    });
                                  }
                                },
                              ),

                              //=======================================================
                              //Delete Lyrics btn
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context:
                                        context, // You need to pass the BuildContext
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm'),
                                        content: const Text(
                                            'Are you sure you want to delete all lyrics?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Dismiss the dialog
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                widget.song.deleteAllLyrics();
                                                widget.lyricsList = [];
                                                songProvider
                                                    .saveSong(widget.song);
                                              });
                                              Navigator.of(context)
                                                  .pop(); // Dismiss the dialog after performing the action
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              //=======================================================
                              //Sync mode button
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor: isEditingEnabled
                                      ? WidgetStateProperty.all(Colors.grey)
                                      : WidgetStateProperty.all(Colors.blue),
                                ),
                                onPressed: () {
                                  setState(() {
                                    //widget.trackPlayer = TrackPlayer(widget.song);
                                    isEditingEnabled = !isEditingEnabled;
                                    widget.logger.d(
                                        "Sync button pressed: ${!isEditingEnabled}");
                                  });
                                },
                                child: const Text('Sync Mode'),
                              ),

                              //===================================================================================================
                              //Play the audio tracks
                              IconButton(
                                onPressed: isEditingEnabled
                                    ? null
                                    : () {
                                        widget.trackPlayer.play();
                                        startTimer();
                                      },
                                icon: const Icon(Icons.play_arrow),
                              ),

                              //===================================================================================================
                              //Stop the audio tracks
                              IconButton(
                                  onPressed: isEditingEnabled
                                      ? null
                                      : () {
                                          stopTimer();
                                          widget.trackPlayer.stop();
                                          clearHighlightedLyrics();
                                        },
                                  icon: const Icon(Icons.stop)),
                              //===================================================================================================
                              //Clear timings
                              IconButton(
                                tooltip: "Clear user timings",
                                onPressed: isEditingEnabled
                                    ? null
                                    : () {
                                        //clear user timing
                                        // stopTimer();
                                        // widget.trackPlayer.stop();
                                        // removeUserTiming();
                                        // clearHighlightedBars();
                                        // rebuildBarList();
                                      },
                                icon: const Icon(Icons.clear_all),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: structures.length,
                          itemBuilder: (context, index) {
                            final structure = structures[index];
                            //structure.thisSection?.scheduleLyrics();

                            return Column(children: <Widget>[
                              Draggable<Section>(
                                data: structure
                                    .thisSection, // This is the data that will be passed to the drag target.
                                feedback: Material(
                                  // Wrap the feedback in Material to avoid transparency issues.
                                  elevation:
                                      4.0, // Optional: Adds shadow to the feedback widget.
                                  child: Text(
                                      structure.thisSection?.section ?? ''),
                                ),
                                child: Text(
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    structure.thisSection?.section ??
                                        ''), // The widget that will remain under the finger when dragging starts.
                              ),
                              ...structure.getLyrics().map((lyric) =>
                                  DragTarget<Section>(
                                    onWillAcceptWithDetails: (data) =>
                                        true, // Decide whether to accept the data
                                    onAcceptWithDetails: (droppedObject) {
                                      widget.logger.d(
                                          "Dropped data: ${droppedObject.data.section}\n\nDropped data: ${lyric.text}");
                                      if (widget.previewSections
                                              .lyricIsInCurrentSection(
                                                  droppedObject.data, lyric) ||
                                          widget.previewSections
                                              .lyricIsInPreviousSection(
                                                  droppedObject.data, lyric)) {
                                        setState(() {
                                          widget.previewSections
                                              .setSectionLyrics(
                                                  destinationSection:
                                                      droppedObject.data,
                                                  lyric: lyric);
                                          widget.song.save();
                                          songProvider.saveSong(widget.song);
                                        });
                                      }
                                    },
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      Color textColor =
                                          candidateData.isNotEmpty ||
                                                  lyric.isHighlighted
                                              ? Colors.blue
                                              : Colors.black;
                                      return Container(
                                        // Optional: Add padding, decoration, etc. if needed
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                widget.logger.d(
                                                    "Tapped: ${lyric.text} @ ${widget.trackPlayer.getCurrentPosition()}");
                                                lyric.startTimeMs = widget
                                                    .trackPlayer
                                                    .getCurrentPosition();
                                              });
                                            },
                                            child: Text(
                                              // "${lyric.text} [${lyric.startTimeMs}, ${lyric.calculatedStartTimeMs}]",
                                              lyric.text,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: textColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                            ]);
                          }),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.grey[200],
                  child: ListView.builder(
                    itemCount: widget.song.sections.length,
                    itemBuilder: (context, i) {
                      // This index is for a section
                      final section = widget.song.sections[i];
                      return ListTile(
                        title: Draggable(
                          feedback: Text(
                            section.section,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          childWhenDragging: Container(),
                          data: section,
                          child: Text(
                            section.section,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
