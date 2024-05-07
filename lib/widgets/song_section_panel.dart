import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SongSectionPanel extends StatelessWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('SongSectionPanel'));

  Section section;

  int requiredRows = 0;

  SongSectionPanel({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    logger.d('SongSectionPanel rebuilt with section: ${section.section}');

    requiredRows = calculateRequiredRows(section);

    return Column(
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
              child: Text(section.section,
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'Myriad Pro',
                  )),
            ),
          ],
        ),

        //================================================================
        //================================================================
        // Section chords

        
          newChord(section.chords![0].name, section.chords![0].beats),
        
        //start row
        //new bar(chord, beats)
        //new chord(chord, beats)
        //end row

       
      ],
    );
  }

  int calculateRequiredRows(Section section) {
    logger.d('calculateRequiredRows: section: ${section.section}');

    int totalBeats = 0;
    section.chords!.forEach((chord) {
      totalBeats += int.parse(chord.beats);
    });

    logger.d('calculateRequiredRows: totalBeats: $totalBeats');
    logger.d(
        'calculateRequiredRows: totalBeats / 16: ${(totalBeats / 16).ceil()}');

    return (totalBeats / 16).ceil();
  }

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
          text: name + '/n' + beats,
          style: const TextStyle(
            fontSize: 30,
            fontFamily: 'Myriad Pro',
            color: Colors.black,
          ),
        ),
      ),
    );
  }


}
