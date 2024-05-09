//==================================================
//ChordPanel.dart
//
// Atomic panels for the chords in a song. Will return a list of chord panels for one chord. Includes logic for:
// - Displaying the chord name with modifiers such as maj, min, 7, 9, dim, aug, etc.
// - Displaying the chord name with a slash for the bass note
// - Bar lines at the start of each bar, and the end of each line
// - Display a '/' to repeat a chord for a beat
// - Show the chord name if a repeated chord runs over a new line, ie. don't show a '/' as the first symbol on a line.

import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ChordPanel {
  static String _timeSignature = '4/4';

  static int modStart(int startingBeat) {
    var timeSignatureParts = _timeSignature.split('/');
    var beatsPerBar = int.parse(timeSignatureParts[0]);

    return startingBeat % beatsPerBar;
  }

  static bool isStartOfBar(int startingBeat) {
    return modStart(startingBeat) == 1;
  }

  static bool isEndOfBar(int startingBeat) {
    return modStart(startingBeat) == 0;
  }

  static List<Widget> buildChordPanels(
      {required Chord chord,
      required int start,
      required String timeSignature,
      required int sectionPosition}) {
    var logger = Logger(level: LoggingUtil.loggingLevel('ChordPanel'));
    _timeSignature = timeSignature;

    logger.d('Building chord panels for chord: $chord');

    List<Widget> chordPanels = [];

    //container for chord name
    chordPanels.add(chordPanel(chord.name, start, sectionPosition,
        modifier: chord.modifications));

    //repeat symbols
    for (var i = 1; i < int.parse(chord.beats); i++) {
      chordPanels.add(chordPanel('/', start + i, sectionPosition));
    }

    return chordPanels;
  }

  static Widget chordPanel(String symbol, int startingBeat, int sectionPosition,
      {String? modifier}) {
    var logger = Logger(level: LoggingUtil.loggingLevel('ChordPanel'));
    var fullSymbol = modifier != null ? '$symbol$modifier' : symbol;
    var isFirstBeat = isStartOfBar(startingBeat);
    var isLastBeat = isEndOfBar(startingBeat);
    var isRepeat = symbol == '/';

    logger.d(
        'Chord panel: $fullSymbol, start: $startingBeat, sectionPosition: $sectionPosition, isBeatOne: $isLastBeat, isRepeat: $isRepeat');

    return IntrinsicWidth(
      child: Container(
        alignment: Alignment.centerLeft,
        height: 80,
        //width: panelWidth,
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        margin: const EdgeInsets.only(top: 10.0, right: 10.0),
        // decoration: BoxDecoration(
        //   //================================================================
        //   //Add a border if this is the start of a bar
        //   border: getChordBorder(isFirstBeat, isLastBeat, sectionPosition),
        // ),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicWidth(
              child: Text(
                symbol,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Myriad Pro',
                  color: isRepeat ? Colors.grey : Colors.black,
                ),
              ),
            ),
            modifier != null
                ? Text(
                    modifier,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Myriad Pro',
                      color: isRepeat ? Colors.grey : Colors.black,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  static getChordBorder(bool isFirstBeat, bool isLastBeat, int sectionPosition) {
    if (sectionPosition == 0) {
      return const Border(
        left: BorderSide(
          color: Colors.black, // Set border color
          width: 2.0, // Set border width
        ),
      );
    // } else if (isLastBeat) {
    //   return const Border(
    //     right: BorderSide(
    //       color: Colors.black, // Set border color
    //       width: 2.0, // Set border width
    //     ),
    //   );
    } else {
      return null;
    }
  }
  
  
}
