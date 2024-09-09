import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:bandbridge/widgets/songs/chord-chart/bar_widget.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class PerformScrollItem extends StatelessWidget {
  int startMs = -1;
  int endMs = -1;
  var lyrics = <Lyric>[];
  var bars = <BarWidget>[];
  bool selected = false;

  PerformScrollItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50 + (lyrics.length * 30.0),
      decoration: BoxDecoration(
        border: selected
            ? Border.all(
                color: Colors.white,
                width: 1,
              )
            : null,
      ),
      child: 
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lyrics.map((lyric) {
              return IntrinsicWidth(
                child: Text(
                  lyric.text,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bars.map((bar) {
              return IntrinsicWidth(
                child: bar,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  addLyric(Lyric lyric) {
    this.lyrics.add(lyric);
  }

  addBars(BarWidget bar) {
    this.bars.add(bar);
  }

  /**
   * Get the start time in milliseconds of the first bar in this scroll item. Returns -1 if not set
   */
  getStartMs() {
    if (bars.isEmpty) {
      return -1;
    }

    return bars[0].bar.calculatedStartTimeMs;
  }

  /**
   * Get the _start_ time in milliseconds of the last bar in this scroll item. Returns -1 if not set.
   */
  getLastBarStartMs() {
    if (bars.isEmpty) {
      return -1;
    }

    return bars.last.bar.calculatedStartTimeMs;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // TODO: implement toString
    return bars.toString() +
        " " +
        lyrics.toString() +
        " " +
        startMs.toString() +
        " " +
        endMs.toString();
  }
}
