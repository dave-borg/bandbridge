import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/utils/logging_util.dart';
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
    logger.d('SongSectionPanel rebuilt with section: ${section.sectionName}');

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
                child: Text(section.sectionName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Myriad Pro',
                    )),
              ),
            ],
          ),
        ],
      ),
    );
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
