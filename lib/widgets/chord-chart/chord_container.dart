import 'package:bandbridge/models/mdl_chord.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class ChordContainer extends StatelessWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('ChordContainer'));
  late Chord chord;

  ChordContainer({super.key, required Chord chord}) {
    this.chord = chord; // Initialize the chord field with the constructor parameter.
  }

  @override
  Widget build(BuildContext context) {
    if (chord.bass != null) {
      logger.d("Chord: ${chord.name}/${chord.bass}");
    }

    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            color: Colors.blue,
            child: Text(chord.name),
          ),
        ),
        Positioned(
          top: 20, // Adjust the positioning to overlap
          left: 20, // Adjust the positioning to overlap
          child: Container(
            color: Colors.red,
            child: Text(
              chord.bass ?? '',
            ),
          ),
        ),
      ],
    );
  }

  //   return FittedBox(
  //       fit: BoxFit.scaleDown,
  //       child: Text(
  //         "${chord.name}${chord.bass != null ? '/${chord.bass}' : ''}",
  //         style: const TextStyle(
  //           fontWeight: FontWeight.bold,
  //           color: Colors.green,
  //         ),
  //       ));
  // }
}
