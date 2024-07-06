import 'dart:async';

import 'package:bandbridge/models/mdl_bar.dart';
import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/models/song_provider.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/songs/audio/track_player.dart';
import 'package:bandbridge/widgets/songs/chord-chart/bar_dialog.dart';
import 'package:bandbridge/widgets/songs/chord-chart/chord_container.dart';
import 'package:flutter/material.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

///
///  * Ah, he ChordChartEditor class, a true masterpiece of the Dart language.
///
///As we dive into the build method, we are greeted with a Column widget, the backbone of this code symphony. It orchestrates a harmonious arrangement of widgets, creating a visually stunning user interface. And what's a great UI without an AppBar? Here, we find a row of IconButtons, each waiting to be pressed and unleash its own unique action.
///
///But the real showstopper lies within the Expanded widget, which takes center stage with a ListView.builder. This virtuoso of a widget dynamically generates a list of items based on the length of the song's structure. It's like a never-ending playlist, ensuring that every section gets its moment in the spotlight.
///
///Now, let's talk about the magic happening inside the itemBuilder. Brace yourself for a journey through the world of chords and bars. The code cleverly constructs a list of bars, each limited to a maximum of 4 beats. It's like a musical measure, perfectly timed and synchronized.
///
///But wait, there's more! The ChordChartEditor also showcases its versatility with the use of GestureDetector. With a simple tap, a dialog box appears, inviting the user to interact and explore. It's like a backstage pass to the inner workings of the code.
///
///And let's not forget the grand finale, where a circular container adorned with the iconic "+" icon steals the show. With a tap on this magnificent creation, another dialog box emerges, inviting the user to add a bar and shape the musical masterpiece even further.
///
///In conclusion, the ChordChartEditor class is a true virtuoso, combining the elegance of Dart with the creativity of a composer. It's a symphony of widgets, a visual feast, and an interactive experience all rolled into one. Just like Richard, Jeremy, and James, this code leaves you in awe and wanting more. Bravo!
///
// ignore: must_be_immutable
class ChordChartEditor extends StatefulWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('ChordChartEditor'));
  final Song song;
  final int? selectedSectionIndex;
  late TrackPlayer trackPlayer;

  ChordChartEditor({super.key, required this.song, this.selectedSectionIndex}) {
    trackPlayer = TrackPlayer(song);
  }

  @override
  // ignore: library_private_types_in_public_api
  _ChordChartEditorState createState() => _ChordChartEditorState();
}

class _ChordChartEditorState extends State<ChordChartEditor> {
  bool isEditingEnabled = true;
  Timer? periodicTimer;
  double barDurationMs = 500.0;
  Map<Section, List<Bar>> sectionBars = {};
  List<TempoBarList> tempoBarLists =
      []; //need this to keep track of the tempo changes

  void startTimer() {
    int currentPlaybackTimeMs = 0;
    periodicTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      currentPlaybackTimeMs = widget.trackPlayer.getCurrentPosition();

      //for (int i = 0; i < sectionBars.length; i++) {
      for (var sectionBarLists in sectionBars.values) {
        for (var thisBar in sectionBarLists) {
          if (currentPlaybackTimeMs >= thisBar.calculatedStartTimeMs &&
              currentPlaybackTimeMs <=
                  thisBar.calculatedStartTimeMs + barDurationMs) {
            // Highlight bar
            if (!thisBar.isHighlighted) {
              setState(() {
                thisBar.isHighlighted = true;
                // widget.logger.d(
                //     "Highlighting bar: ${thisBar.id}\nCurrent playback time: $currentPlaybackTimeMs\nCalculated start time: ${thisBar.calculatedStartTimeMs}\nUser Start Time: ${thisBar.startTimeMs}");
              });
            }
          } else {
            // Unhighlight bar
            if (thisBar.isHighlighted) {
              setState(() {
                thisBar.isHighlighted = false;
              });
            }
          }
        }
      }
    });
  }

  void initBarSchedule() {
    int minuteInMs = 60 * 1000;
    double? tempoBpm = double.tryParse(widget.song.tempo);
    int beatsPerBar = int.parse(widget.song.timeSignature.split('/')[0]);
    double beatDuration = minuteInMs / tempoBpm!;
    barDurationMs = beatDuration * beatsPerBar;
    tempoBarLists = [];

    var thisTempoList = TempoBarList();
    tempoBarLists.add(thisTempoList);
    thisTempoList.startMs = 0;

    for (int i = 0; i < widget.song.sections.length; i++) {
      var thisSection = sectionBars.keys.elementAt(i);
      if (thisSection.bars != null) {
        for (var j = 0; j < thisSection.bars!.length; j++) {
          var thisBar = thisSection.bars![j];

          //this bar has a start time set by the user
          if (thisBar.startTimeMs != -1) {
            thisTempoList.endMs = thisBar.startTimeMs;
            thisTempoList.calculateSchedule();
            thisTempoList = TempoBarList();
            tempoBarLists.add(thisTempoList);
          } else {
            thisTempoList.endMs += barDurationMs.round();
          }
          thisTempoList.addBar(thisBar);

          //last bar in the song
          if (i == widget.song.sections.length - 1 &&
              j == thisSection.bars!.length - 1) {
            // thisTempoList.endMs =
            //     thisBar.calculatedStartTimeMs.round() + barDurationMs.round();
            thisTempoList.calculateSchedule(
                isLastTempo: true, defaultDuration: barDurationMs.round());
          }
        }
      }
    }
  }

  void stopTimer() {
    periodicTimer?.cancel();
  }

  @override
  void dispose() {
    periodicTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    rebuildBarList();
  }

  @override
  void didUpdateWidget(ChordChartEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    rebuildBarList();
  }

  void rebuildBarList() {
    sectionBars = {};
    for (var thisSection in widget.song.sections) {
      List<Bar> newBars = [];
      for (var thisBar in thisSection.bars!) {
        if (thisBar.startTimeMs != -1) {
          widget.logger.d("thisBar: ${thisBar.startTimeMs}");
        }

        newBars.add(thisBar);
      }
      sectionBars.addEntries([MapEntry(thisSection, newBars)]);
    }

    initBarSchedule();
  }

  List<Bar>? getSectionBars(Section thisSection) {
    return sectionBars[thisSection];
  }

  void removeUserTiming() {
    for (var sectionBarLists in sectionBars.values) {
      for (var thisBar in sectionBarLists) {
        if (thisBar.startTimeMs != -1) {
          setState(() {
            thisBar.startTimeMs = -1;
            return;
          });
        }
      }
    }
  }

  clearHighlightedBars() {
    for (var sectionBarLists in sectionBars.values) {
      for (var thisBar in sectionBarLists) {
        if (thisBar.isHighlighted) {
          setState(() {
            thisBar.isHighlighted = false;
            return;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context);

    return Column(
      children: [
        AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //=======================================================
              //Edit mode Button
              TextButton(
                style: ButtonStyle(
                  backgroundColor: isEditingEnabled
                      ? WidgetStateProperty.all(Colors.blue)
                      : WidgetStateProperty.all(Colors.grey),
                ),
                onPressed: () {
                  setState(() {
                    isEditingEnabled = !isEditingEnabled;
                    widget.logger.d("Edit button pressed: $isEditingEnabled");
                  });
                },
                child: const Text('Edit Mode'),
              ),
              Row(
                children: [
                  //=======================================================
                  //Sync mode Button
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: isEditingEnabled
                          ? WidgetStateProperty.all(Colors.grey)
                          : WidgetStateProperty.all(Colors.blue),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.trackPlayer = TrackPlayer(widget.song);
                        isEditingEnabled = !isEditingEnabled;
                        widget.logger
                            .d("Sync button pressed: ${!isEditingEnabled}");
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
                            startTimer();
                            widget.trackPlayer.play();
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
                              clearHighlightedBars();
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
                            stopTimer();
                            widget.trackPlayer.stop();
                            removeUserTiming();
                            clearHighlightedBars();
                            rebuildBarList();
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
            //itemCount: widget.song.sections.length,
            itemCount: sectionBars.length,
            itemBuilder: (context, currentSection) {
              if (widget.selectedSectionIndex != null &&
                  widget.selectedSectionIndex != currentSection) {
                return Container(); // Return an empty container if sectionIndex is not null and does not match the current index
              }

              List<Bar> sectionBars = [];

              // Assuming getSectionBars returns a List? and you want to add its items to sectionBars if it's not null
              final bars = getSectionBars(widget.song.sections[currentSection]);
              if (bars != null) {
                sectionBars.addAll(bars);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //===================================================================================================
                  //Section Title
                  Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      widget.song.sections[currentSection].section,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: [
                      ...sectionBars.map((bar) {
                        //===================================================================================================
                        //add the bar to the schedule

                        return GestureDetector(
                          onTap: () async {
                            if (isEditingEnabled) {
                              final Bar? result = await showDialog<Bar>(
                                context: context,
                                builder: (BuildContext context) {
                                  return BarDialog(
                                      song: widget.song,
                                      bar: bar,
                                      dialogTitle: 'Edit Bar');
                                },
                              );

                              if (result != null) {
                                widget.logger.d("Returned edited bar: $result");
                                setState(() {
                                  int index = widget
                                      .song.sections[currentSection].bars!
                                      .indexOf(bar);
                                  if (index != -1) {
                                    widget.song.sections[currentSection]
                                        .bars![index] = result;
                                  }
                                  songProvider.saveSong(widget.song);
                                  widget.logger.d(result.getDebugOutput(
                                      "Saving song with edited bar"));
                                  widget.song.save();
                                });
                              }
                            } else {
                              bar.startTimeMs =
                                  widget.trackPlayer.getCurrentPosition();
                              //widget.song.save();
                              songProvider.saveSong(widget.song);
                              rebuildBarList();

                              widget.logger.d(
                                  "Tap on bar.\nCurrent Time: ${widget.trackPlayer.getCurrentPosition()}ms\n${bar.getDebugOutput("Bar")}");
                            }
                          },

                          //=======================================================
                          //Swipe to delete the bar
                          child: Dismissible(
                            key: Key(bar
                                .id), // Ensure you have a unique identifier for each bar
                            direction: DismissDirection
                                .horizontal, // Allows swiping in both directions
                            confirmDismiss: (direction) {
                              // Check if editing is enabled
                              if (isEditingEnabled) {
                                // Allow dismiss (swipe)
                                return Future.value(true);
                              } else {
                                // Prevent dismiss (swipe)
                                return Future.value(false);
                              }
                            },
                            onDismissed: (direction) {
                              // Remove the bar from the list
                              int index = widget
                                  .song.sections[currentSection].bars!
                                  .indexOf(bar);
                              setState(() {
                                if (index != -1) {
                                  widget.song.sections[currentSection].bars!
                                      .removeAt(index);
                                  songProvider.saveSong(widget.song);
                                  rebuildBarList();
                                }
                              });

                              // Optionally, show a snackbar or some feedback
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Bar removed')),
                              );
                            },
                            background: Container(
                                color: Colors.red), // Background when swiping
                            child: LongPressDraggable(
                              data: bar,
                              feedback: Container(
                                width: 150.0,
                                height: 45.0,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: const Color.fromARGB(74, 97, 97, 97),
                                ),
                                child: const Text("Copying bar...",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(199, 93, 93, 93))),
                              ),

                              //===================================================================================================
                              //Bar while being dragged
                              childWhenDragging: Container(
                                width: 200.0,
                                height: 50.0,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Wrap(
                                  spacing: 6.0, // Adjust spacing as needed
                                  children: bar.beats
                                      .map((beat) {
                                        List<Widget> widgets = [];

                                        if (beat.chord != null) {
                                          widgets.add(
                                            ChordContainer(
                                              chord: beat.chord!,
                                              width: 35,
                                              height: 50,
                                            ),
                                          );
                                        } else {
                                          widgets.add(
                                            const SizedBox(
                                              width: 35,
                                              height: 30,
                                              child: Text(
                                                " /",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                          );
                                        }

                                        return widgets;
                                      })
                                      .expand((i) => i)
                                      .toList(), // Flatten the list of lists into a single list
                                ),
                              ),

                              //===================================================================================================
                              //Bar container
                              child: Container(
                                width: 200.0,
                                height: 50.0,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: bar.isHighlighted
                                      ? const Color.fromARGB(255, 78, 119, 188)
                                      : const Color.fromARGB(
                                          255, 255, 255, 255),
                                ),
                                child: Wrap(
                                  spacing: 6.0, // Adjust spacing as needed
                                  children: bar.beats
                                      .map((beat) {
                                        List<Widget> widgets = [];

//First widget - debug output for the bar
                                        // if (bar.beats.indexOf(beat) == 0) {
                                        //   widgets.add(
                                        //     SizedBox(
                                        //       width: 35,
                                        //       height: 30,
                                        //       child: Text(
                                        //         "${bar.startTimeMs}ms\n${bar.calculatedStartTimeMs}ms",
                                        //         style: const TextStyle(
                                        //             fontSize: 6),
                                        //       ),
                                        //     ),
                                        //   );
                                        // }

                                        if (beat.chord != null) {
                                          widgets.add(
                                            ChordContainer(
                                              chord: beat.chord!,
                                              //width: 35,
                                              width: 15,
                                              height: 50,
                                            ),
                                          );
                                        } else {
                                          widgets.add(
                                            const SizedBox(
                                              //width: 35,
                                              width: 15,
                                              height: 30,
                                              child: Text(
                                                " /",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                          );
                                        }

                                        return widgets;
                                      })
                                      .expand((i) => i)
                                      .toList(), // Flatten the list of lists into a single list
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      GestureDetector(
                        onTap: () async {
                          final Bar result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BarDialog(
                                  song: widget.song,
                                  bar: Bar(),
                                  dialogTitle: 'Add Bar');
                            },
                          );
                          widget.logger.d("Returned new bar: $result");
                          final section = widget.song.sections[currentSection];
                          if (section.bars != null) {
                            setState(() {
                              section.bars!.add(result);

                              songProvider.saveSong(widget.song);
                              rebuildBarList();

                              widget.logger.d(result
                                  .getDebugOutput("Saving song with new bar"));
                            });
                          } else {
                            // Handle the case where bars is null or result is null
                            widget.logger.d(
                                "Bars is null or no result returned from dialog");
                          }
                        },
                        child: DragTarget(
                          onAcceptWithDetails: (receivedBar) {
                            Bar droppedBar = receivedBar.data as Bar;

                            setState(() {
                              widget.logger.d("Received bar: $droppedBar");
                              final section =
                                  widget.song.sections[currentSection];
                              section.bars!.add(droppedBar.copy());
                              songProvider.saveSong(widget.song);
                              rebuildBarList();

                              widget.song.save();
                            });
                          },
                          builder: (context, candidateData, rejectedData) {
                            return isEditingEnabled
                                ? Container(
                                    width: 200.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 216, 216, 216)),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(8.0),
                                      decoration: const BoxDecoration(
                                        color: Colors.blue, // Button color
                                        shape:
                                            BoxShape.circle, // Circular shape
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.add, // '+' icon
                                        color: Colors.white, // Icon color
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                        // child:
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class TempoBarList {
  var logger = Logger(level: LoggingUtil.loggingLevel('TempoBarList'));
  List<Bar> bars = [];
  int startMs = 0;
  int endMs = 0;

  void addBar(Bar bar) {
    bars.add(bar);
  }

  void calculateSchedule(
      {bool isLastTempo = false, int defaultDuration = 100}) {
    // If the first bar has a start time, use that as the start time for the list
    // A bar with a user-set start time should only be the first bar in the list
    if (bars.isNotEmpty && bars[0].startTimeMs != -1) {
      startMs = bars[0].startTimeMs;
    }

    int diffMs = endMs - startMs;
    double barDurationMs = diffMs / bars.length;

    // logger.d(
    //     "Start: $startMs\nEnd: $endMs\nDiff: $diffMs\nBar duration: $barDurationMs\nBars: ${bars.length}");

    for (int i = 0; i < bars.length; i++) {
      var thisBar = bars[i];

      if (!isLastTempo) {
        if (thisBar.startTimeMs != -1) {
          thisBar.calculatedStartTimeMs = thisBar.startTimeMs;
        } else {
          thisBar.calculatedStartTimeMs = startMs + (barDurationMs * i).round();
        }
      } else {
        thisBar.calculatedStartTimeMs = startMs + (defaultDuration * i).round();
      }
    }
    // if (bars.isNotEmpty) {
    //   logger.d("Bar length: ${bars.length}");
    //   logger.d(
    //       "Bar 1\nCalculated Start: ${bars[0].calculatedStartTimeMs}\nUser start: ${bars[0].startTimeMs}\n\nBar 2\nCalculated Start: ${bars[1].calculatedStartTimeMs}\nUser start: ${bars[1].startTimeMs}\n\nBar 3\nCalculated Start: ${bars[2].calculatedStartTimeMs}\nUser start: ${bars[2].startTimeMs}\n");
    // }
  }

  String debugInfo() {
    String output = "TempoBarList\n";
    output +=
        "====================\nStart: $startMs\nEnd: $endMs\nDuration: ${(endMs - startMs) / bars.length}\nBars: ${bars.length}\n\n";
    return output;
  }
}
