import 'dart:ffi' hide Size;

import 'package:bandbridge/models/mdl_chord.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class ChordContainer extends StatelessWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('ChordContainer'));
  late Chord chord;
  double? width;
  double? height;

  ChordContainer(
      {super.key, required Chord chord, double? width, double? height}) {
    this.chord =
        chord; // Initialize the chord field with the constructor parameter.
    this.width =
        width ?? 40.0; // If the width parameter is null, set it to 40.0.
    this.height =
        height ?? 50.0; // If the height parameter is null, set it to 60.0.
  }

  @override
  Widget build(BuildContext context) {
    if (chord.bass != null) {
      logger.d("Chord: ${chord.rootNote}/${chord.bass}");
    }

    return Container(
      margin: const EdgeInsets.all(2),
      width: width,
      child: SizedBox(
        // width: width, // Specify your desired width
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Text(chord.rootNote + chord.renderElements(),
                  style: const TextStyle(fontSize: 18)),
            ),
            if (chord.bass != null)
              Positioned(
                top: 25, // Adjust the positioning to overlap
                left: 20, // Adjust the positioning to overlap
                child: Text(chord.bass ?? '',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 146, 141, 141))),
              ),
            if (chord.bass != null)
              CustomPaint(
                size: const Size(200, 200), // Canvas size
                painter: DiagonalLinePainter(),
              ),
          ],
        ),
      ),
    );
  }
}

class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 146, 141, 141) // Line color
      ..strokeWidth = 2; // Line width

    // Starting point of the line (bottom-right of the first Text widget)
    const start = Offset(10, 42); // Adjust these values as needed
    // Ending point of the line (top-left of the second Text widget)
    const end = Offset(30, 20); // Adjust these values as needed

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
