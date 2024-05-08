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

  static bool isStartOfBar(int start) {
    var logger = Logger(level: LoggingUtil.loggingLevel('ChordPanel'));

    var timeSignatureParts = _timeSignature.split('/');
    var beatsPerBar = int.parse(timeSignatureParts[0]);
    var beatValue = int.parse(timeSignatureParts[1]);

    var isStartOfBar = start % beatsPerBar == 1;

    logger.d(
        'start: $start \ntimeSignature: $_timeSignature \nbeatsPerBar: $beatsPerBar \nbeatValue: $beatValue \nisStartOfBar: $isStartOfBar');

    return isStartOfBar;
  }

  static List<Widget> buildChordPanels(
      {required Chord chord,
      required int start,
      required String timeSignature}) {
    var logger = Logger(level: LoggingUtil.loggingLevel('ChordPanel'));
    _timeSignature = timeSignature;

    logger.d('Building chord panels for chord: $chord');

    List<Widget> chordPanels = [];

    //container for chord name
    chordPanels.add(chordPanel(chord.name, start, modifier: chord.modifications));

    //repeat symbols
    for (var i = 1; i < int.parse(chord.beats); i++) {
      chordPanels.add(chordPanel('/', start + i));
    }

    return chordPanels;
  }

  static Widget chordPanel(String symbol, int startingBeat,
      {String? modifier}) {
    var logger = Logger(level: LoggingUtil.loggingLevel('ChordPanel'));
    var isBeatOne = isStartOfBar(startingBeat);
    var isRepeat = symbol == '/';
    double panelWidth = 40;

    //dynamic width for chord panel
    if (isRepeat) {
      panelWidth = 20;
    } else if (symbol.length == 1) {
      panelWidth = 30;
    } else {
      panelWidth = 40 + (symbol.length - 1) * 10;
    }

    logger.d(
        'Chord panel: $symbol, start: $startingBeat, isBeatOne: $isBeatOne, isRepeat: $isRepeat, panelWidth: $panelWidth');

    return Container(
      alignment: Alignment.centerLeft,
      height: 80,
      width: panelWidth,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      margin: const EdgeInsets.only(top: 10.0, right: 10.0),
      decoration: BoxDecoration(
        //================================================================
        //Add a border if this is the start of a bar
        border: isBeatOne
            ? const Border(
                left: BorderSide(
                  color: Colors.black, // Set border color
                  width: 2.0, // Set border width
                ),
              )
            : null,
      ),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            symbol,
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Myriad Pro',
              color: isRepeat ? Colors.grey : Colors.black,
            ),
          ),
          modifier != null
              ? Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Myriad Pro',
                    color: isRepeat ? Colors.grey : Colors.black,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
