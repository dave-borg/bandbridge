import 'dart:math';

import 'package:bandbridge/models/mdl_chord.dart';
import 'package:bandbridge/widgets/chord-chart/chord_container.dart';
import 'package:flutter/material.dart';
import 'package:bandbridge/models/mdl_song.dart';

/**
 * Ah, the ChordChartEditor class, a true masterpiece of the Dart language. 

As we dive into the build method, we are greeted with a Column widget, the backbone of this code symphony. It orchestrates a harmonious arrangement of widgets, creating a visually stunning user interface. And what's a great UI without an AppBar? Here, we find a row of IconButtons, each waiting to be pressed and unleash its own unique action.

But the real showstopper lies within the Expanded widget, which takes center stage with a ListView.builder. This virtuoso of a widget dynamically generates a list of items based on the length of the song's structure. It's like a never-ending playlist, ensuring that every section gets its moment in the spotlight.

Now, let's talk about the magic happening inside the itemBuilder. Brace yourself for a journey through the world of chords and bars. The code cleverly constructs a list of bars, each limited to a maximum of 4 beats. It's like a musical measure, perfectly timed and synchronized.

But wait, there's more! The ChordChartEditor also showcases its versatility with the use of GestureDetector. With a simple tap, a dialog box appears, inviting the user to interact and explore. It's like a backstage pass to the inner workings of the code.

And let's not forget the grand finale, where a circular container adorned with the iconic "+" icon steals the show. With a tap on this magnificent creation, another dialog box emerges, inviting the user to add a bar and shape the musical masterpiece even further.

In conclusion, the ChordChartEditor class is a true virtuoso, combining the elegance of Dart with the creativity of a composer. It's a symphony of widgets, a visual feast, and an interactive experience all rolled into one. Just like Richard, Jeremy, and James, this code leaves you in awe and wanting more. Bravo!
 */
class ChordChartEditor extends StatelessWidget {
  final Song song;
  final int? sectionIndex;

  const ChordChartEditor({super.key, required this.song, this.sectionIndex});

  @override
  Widget build(BuildContext context) {
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
        )),
        Expanded(
          child: ListView.builder(
            itemCount: song.structure.length,
            itemBuilder: (context, i) {
              if (sectionIndex != null && sectionIndex != i) {
                return Container(); // Return an empty container if sectionIndex is not null and does not match the current index
              }

              // Create a new list of bars where each bar has a maximum of 4 beats
              List<List<Chord>> bars = [];
              List<Chord> currentBar = [];
              int currentBeats = 0;
              for (var chord in song.structure[i].chords!) {
                int beats = int.parse(chord.beats);
                while (beats > 0) {
                  int beatsToAdd = min(4 - currentBeats, beats);
                  currentBar.add(Chord(
                    name: chord.name,
                    beats: beatsToAdd.toString(),
                    bass: chord.bass,
                  ));
                  currentBeats += beatsToAdd;
                  beats -= beatsToAdd;
                  if (currentBeats == 4) {
                    bars.add(currentBar);
                    currentBar = [];
                    currentBeats = 0;
                  }
                }
              }
              if (currentBar.isNotEmpty) {
                bars.add(currentBar);
              }

              // Create a list of keys for the containers
              List<GlobalKey> keys =
                  List<GlobalKey>.generate(bars.length, (index) => GlobalKey());

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      song.structure[i].section,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: [
                      ...bars.map((bar) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Container Tapped'),
                                  content:
                                      const Text('You tapped the container!'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
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
                              children: bar.expand((chord) {
                                // Create a list of widgets for each chord and its slashes
                                List<Widget> widgets = [
                                  ChordContainer(
                                      chord:
                                          chord), // Use ChordContainer for the chord
                                  // Text(
                                  //     "${chord.name} ${chord.bass}"), // Use Text for the chord
                                ];
                                // Add slashes for beats, if any
                                int beats = int.parse(chord.beats) - 1;
                                for (int i = 0; i < beats; i++) {
                                  widgets.add(const SizedBox(
                                    width: 40, // Specify your desired width
                                    height: 60,
                                    child: Text(" /",
                                        style: TextStyle(fontSize: 24)),
                                  )); // Add a Text widget for each slash, with a leading space for separation
                                }
                                return widgets;
                              }).toList(),
                            ),
                          ),
                        );
                      }).toList(),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Add a Bar'),
                                content: const Text('You tapped the bar!'),
                                actions: [
                                  TextButton(
                                    child: const Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
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
