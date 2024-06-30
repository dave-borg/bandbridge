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
  List<int> userScheduledBars = [];
  //List<ScheduledBar> bars = [];
  double barDurationMs = 500.0;
  Map<Section, List<ScheduledBar>> sectionBars = {};

  void startTimer() {
    int currentPlaybackTimeMs = 0;
    periodicTimer =
        Timer.periodic(Duration(milliseconds: barDurationMs.round()), (timer) {
      currentPlaybackTimeMs = widget.trackPlayer.getCurrentPosition();

      //for (int i = 0; i < sectionBars.length; i++) {
      for (var sectionBarLists in sectionBars.values) {
        for (var thisBar in sectionBarLists) {
          if (currentPlaybackTimeMs >= thisBar.bar.calculatedStartTimeMs &&
              currentPlaybackTimeMs <=
                  thisBar.bar.calculatedStartTimeMs + barDurationMs) {
            // Highlight bar
            widget.logger.d("Highlighting bar: $thisBar");
            setState(() {
              thisBar.isHighlighted = true;
            });
          } else {
            // Unhighlight bar
            setState(() {
              thisBar.isHighlighted = false;
            });
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

    int barCount = 0;

    for (var thisSection in widget.song.sections) {
      for (int i = 0; i < thisSection.bars!.length; i++) {
        int calculatedStartTime =
            ((barCount + i + 1) * barDurationMs).round().toInt();
        thisSection.bars![i].calculatedStartTimeMs = calculatedStartTime;
        widget.logger
            .d("Calculated start time for bar $i: $calculatedStartTime");
      }
      barCount += thisSection.bars!.length;
    }
  }

  void stopTimer() {
    periodicTimer?.cancel();
  }

  // void addToSchedule(ScheduledBar scheduledBar) {
  //   userScheduledBars.add(scheduledBar.bar.startTimeMs);
  //   bars.add(scheduledBar);
  // }

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

  void rebuildBarList() {
    sectionBars = {};
    for (var thisSection in widget.song.sections) {
      List<ScheduledBar> newBars = [];
      for (var thisBar in thisSection.bars!) {
        newBars.add(ScheduledBar(thisBar));
      }
      sectionBars.addEntries([MapEntry(thisSection, newBars)]);
    }

    initBarSchedule();
  }

  List<ScheduledBar>? getSectionBars(Section thisSection) {
    return sectionBars[thisSection];
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context);

    widget.logger.d(widget.song.getDebugOutput("SongEditor"));

    return Column(
      children: [
        AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
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
                            //rebuildBarList();
                            startTimer();
                            widget.trackPlayer.play();
                          },
                    icon: const Icon(Icons.play_arrow),
                  ),
                  IconButton(
                    onPressed: isEditingEnabled ? null : () {},
                    icon: const Icon(Icons.pause),
                  ),
                  //===================================================================================================
                  //Stop the audio tracks
                  IconButton(
                      onPressed: isEditingEnabled
                          ? null
                          : () {
                              stopTimer();
                              widget.trackPlayer.stop();
                            },
                      icon: const Icon(Icons.stop)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.song.sections.length,
            itemBuilder: (context, currentSection) {
              if (widget.selectedSectionIndex != null &&
                  widget.selectedSectionIndex != currentSection) {
                return Container(); // Return an empty container if sectionIndex is not null and does not match the current index
              }

              List<ScheduledBar> sectionBars = [];

              if (widget.song.sections[currentSection].bars != null) {
                sectionBars.addAll(
                    getSectionBars(widget.song.sections[currentSection])!);
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
                      ...sectionBars.map((scheduledBar) {
                        //===================================================================================================
                        //add the bar to the schedule
                        //addToSchedule(scheduledBar);
                        //initBarSchedule();

                        return GestureDetector(
                          onTap: () async {
                            if (isEditingEnabled) {
                              final Bar result = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return BarDialog(
                                      song: widget.song,
                                      bar: scheduledBar.bar,
                                      dialogTitle: 'Edit Bar');
                                },
                              );
                              widget.logger.d("Returned edited bar: $result");
                              setState(() {
                                int index = widget
                                    .song.sections[currentSection].bars!
                                    .indexOf(scheduledBar.bar);
                                if (index != -1) {
                                  widget.song.sections[currentSection]
                                      .bars![index] = result;
                                }
                                songProvider.saveSong(widget.song);
                                widget.logger.d(result.getDebugOutput(
                                    "Saving song with edited bar"));
                                widget.song.save();
                              });
                            } else {
                              widget.logger.d(
                                  "Tap on bar. Set the sync time\n${widget.trackPlayer.getCurrentPosition()}ms");
                              scheduledBar.bar.startTimeMs =
                                  widget.trackPlayer.getCurrentPosition();
                            }
                          },
                          child: Dismissible(
                            key: Key(scheduledBar.bar
                                .id), // Ensure you have a unique identifier for each bar
                            direction: DismissDirection
                                .horizontal, // Allows swiping in both directions
                            onDismissed: (direction) {
                              // Remove the bar from the list
                              setState(() {
                                //int currentSectionIndex = // Determine the current section index
                                int index = widget
                                    .song.sections[currentSection].bars!
                                    .indexOf(scheduledBar.bar);
                                if (index != -1) {
                                  widget.song.sections[currentSection].bars!
                                      .removeAt(index);
                                  songProvider
                                      .saveSong(widget.song); // Save changes
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
                              data: scheduledBar,
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
                                    style: TextStyle(fontSize: 10)),
                              ),

                              //===================================================================================================
                              //Bar while being dragged
                              childWhenDragging: Container(
                                width: 200.0,
                                height: 60.0,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Wrap(
                                  spacing: 6.0, // Adjust spacing as needed
                                  children: scheduledBar.bar.beats
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
                                  color: scheduledBar.isHighlighted
                                      ? const Color.fromARGB(255, 78, 119, 188)
                                      : const Color.fromARGB(
                                          255, 255, 255, 255),
                                ),
                                child: Wrap(
                                  spacing: 6.0, // Adjust spacing as needed
                                  children: scheduledBar.bar.beats
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
                              widget.song.save();
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
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 216, 216, 216)),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 16.0),
                                      decoration: const BoxDecoration(
                                        color: Colors.blue, // Button color
                                        shape:
                                            BoxShape.circle, // Circular shape
                                      ),
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

//Wrap the Bar class with an isHighlighted property. I don't want to include this
//in the Bar class as it's purely related to how the Bar is being displayed.
class ScheduledBar {
  Bar bar;
  bool isHighlighted = false;

  ScheduledBar(this.bar);
}
