import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/chord-chart/bar_container.dart';
import 'package:bandbridge/widgets/chord_panel.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class SongSectionPanel extends StatelessWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('SongSectionPanel'));

  Section section;

  // int requiredRows = 0;

  int startingPositionRunningCount = 1;
  int sectionPosition = 0;

  SongSectionPanel({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    logger.d('SongSectionPanel rebuilt with section: ${section.section}');

    return SizedBox(
      width: 610,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //================================================================
              //================================================================
              // Section name
              Container(
                alignment: Alignment.centerLeft,
                height: 40,
                width: 140,
                margin: const EdgeInsets.only(top: 30.0),
                child: Text(section.section,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Myriad Pro',
                    )),
              ),
            ],
          ),

          //================================================================
          //================================================================
          // Section chords
          Wrap(
            children: chunk<Widget>(
              section.chords!.expand((thisChord) {
                var chordPanels = ChordPanel.buildChordPanels(
                  chord: thisChord,
                  start: startingPositionRunningCount,
                  timeSignature: "4/4",
                  sectionPosition: sectionPosition,
                );

                startingPositionRunningCount += int.parse(thisChord.beats);

                return chordPanels;
              }).toList(),
              4, //chunk size
            )
                .map((barChords) => BarContainer(
                    Wrap(
                      children: barChords,
                    ),
                    sectionPosition++))
                .toList(),
          )
        ],
      ),
    );
  }

  // int calculateRequiredRows(Section section) {
  //   logger.d('calculateRequiredRows: section: ${section.section}');

  //   int totalBeats = 0;
  //   for (var chord in section.chords!) {
  //     totalBeats += int.parse(chord.beats);
  //   }

  //   return (totalBeats / 16).ceil();
  // }

  Container newChord(String name, String beats) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(5.0),
      height: 80,
      width: 140,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.black, // Change this color to the one you prefer
            width: 3.0, // Change this value to the one you prefer
          ),
        ),
      ),
      child: RichText(
        text: TextSpan(
          text: '$name/n$beats',
          style: const TextStyle(
            fontSize: 30,
            fontFamily: 'Myriad Pro',
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  List<List<T>> chunk<T>(List<T> list, int chunkSize) {
    var chunks = <List<T>>[];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }
}
