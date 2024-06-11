import 'package:bandbridge/models/mdl_chord.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class ChordContainer extends StatelessWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('ChordContainer'));
  late Chord chord;

  ChordContainer({super.key, required Chord chord}) {
    this.chord =
        chord; // Initialize the chord field with the constructor parameter.
  }

  @override
  Widget build(BuildContext context) {
    if (chord.bass != null) {
      logger.d("Chord: ${chord.name}/${chord.bass}");
    }

    return Container(
      child: SizedBox(
        width: 40, // Specify your desired width
        height: 60,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Text(chord.name, style: const TextStyle(fontSize: 30)),
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
