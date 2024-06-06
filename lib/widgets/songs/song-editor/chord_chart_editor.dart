import 'dart:math';

import 'package:bandbridge/models/mdl_chord.dart';
import 'package:flutter/material.dart';
import 'package:bandbridge/models/mdl_song.dart';

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
                    children: bars.map((bar) {
                      return Container(
                        key: keys[bars.indexOf(bar)],
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          bar
                              .map((chord) =>
                                  '${chord.name} ${List.filled(int.parse(chord.beats) - 1, "/").join(" ")}')
                              .join(' '),
                        ),
                      );
                    }).toList(),
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
