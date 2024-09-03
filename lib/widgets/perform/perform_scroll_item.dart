import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:bandbridge/widgets/songs/chord-chart/bar_widget.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class PerformScrollItem extends StatelessWidget {
  final Widget displayWidget;
  final bool isHeader;
  final int startMs;
  var lyrics;
  var bars;

  PerformScrollItem({
    Key? key,
    required this.displayWidget,
    required this.isHeader,
    required this.startMs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return displayWidget;
  }

  addLyric(Lyric lyric) {
    this.lyrics.add(lyric);
  }

  addBars(BarWidget bar) {
    this.bars.add(bar);
  }

}