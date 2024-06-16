import 'package:bandbridge/models/mdl_bar.dart';
import 'package:bandbridge/models/song_provider.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/chord-chart/bar_dialog.dart';
import 'package:bandbridge/widgets/chord-chart/chord_container.dart';
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
class ChordChartEditor extends StatefulWidget {
  final Song song;
  final int? selectedSectionIndex;

  const ChordChartEditor(
      {super.key, required this.song, this.selectedSectionIndex});

  @override
  // ignore: library_private_types_in_public_api
  _ChordChartEditorState createState() => _ChordChartEditorState();
}

class _ChordChartEditorState extends State<ChordChartEditor> {
  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context);
    var logger = Logger(level: LoggingUtil.loggingLevel('ChordChartEditor'));

    logger.d(widget.song.getDebugOutput("SongEditor"));

    return Column(
      children: [
        AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Add your onPressed code here.
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Add your onPressed code here.
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Add your onPressed code here.
                },
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

              // Create a new list of bars where each bar has a maximum of 4 beats
              List<Bar> bars = [];
              bars = widget.song.sections[currentSection].bars!;

              // Create a list of keys for the containers
              List<GlobalKey> keys =
                  List<GlobalKey>.generate(bars.length, (index) => GlobalKey());

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      ...bars.map((bar) {
                        return GestureDetector(
                          onTap: () async {
                            final Bar result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BarDialog(
                                    song: widget.song,
                                    bar: bar,
                                    dialogTitle: 'Edit Bar');
                              },
                            );
                            logger.d("Returned edited bar: $result");
                            setState(() {
                              int index = widget
                                  .song.sections[currentSection].bars!
                                  .indexOf(bar);
                              if (index != -1) {
                                widget.song.sections[currentSection]
                                    .bars![index] = result;
                              }
                              songProvider.saveSong(widget.song);
                              logger.d(result.getDebugOutput(
                                  "Saving song with edited bar"));
                              widget.song.save();
                            });
                          },
                          child: Dismissible(
                            key: Key(bar
                                .id), // Ensure you have a unique identifier for each bar
                            direction: DismissDirection
                                .horizontal, // Allows swiping in both directions
                            onDismissed: (direction) {
                              // Remove the bar from the list
                              setState(() {
                                //int currentSectionIndex = // Determine the current section index
                                int index = widget
                                    .song.sections[currentSection].bars!
                                    .indexOf(bar);
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
                              data: bar,
                              feedback: Container(
                                width: 200.0,
                                height: 60.0,
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
                              child: Container(
                                width: 200.0,
                                height: 60.0,
                                key: keys[bars.indexOf(bar)],
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
                          logger.d("Returned new bar: $result");
                          final section = widget.song.sections[currentSection];
                          if (section.bars != null) {
                            setState(() {
                              section.bars!.add(result);
                              songProvider.saveSong(widget.song);

                              logger.d(result
                                  .getDebugOutput("Saving song with new bar"));
                              widget.song.save();
                            });
                          } else {
                            // Handle the case where bars is null or result is null
                            logger.d(
                                "Bars is null or no result returned from dialog");
                          }
                        },
                        child: DragTarget(
                          onAcceptWithDetails: (receivedBar) {
                            Bar droppedBar = receivedBar.data as Bar;

                            setState(() {
                              logger.d("Received bar: $droppedBar");
                              final section =
                                  widget.song.sections[currentSection];
                              section.bars!.add(droppedBar.copy());
                              songProvider.saveSong(widget.song);

                              widget.song.save();
                            });
                          },
                          builder: (context, candidateData, rejectedData) {
                            return Container(
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
                                  shape: BoxShape.circle, // Circular shape
                                ),
                                child: const Icon(
                                  Icons.add, // '+' icon
                                  color: Colors.white, // Icon color
                                ),
                              ),
                            );
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
