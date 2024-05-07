import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class SongArrangementPanel extends StatelessWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('SongArrangementPanel'));

  Song song;

  SongArrangementPanel({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        children: [
          // Toolbar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 30.0, // Your desired width
                child: IconButton(
                  padding: EdgeInsets.zero, // Remove padding
                  icon: const Icon(Icons.add, size: 20.0), // Set icon size
                  onPressed: () {
                    // Handle add button press
                  },
                ),
              ),
              SizedBox(
                width: 30.0, // Your desired width
                child: IconButton(
                  padding: EdgeInsets.zero, // Remove padding
                  icon: const Icon(Icons.edit, size: 20.0), // Set icon size
                  onPressed: () {
                    // Handle add button press
                  },
                ),
              ),
              SizedBox(
                width: 30.0, // Your desired width
                child: IconButton(
                  padding: EdgeInsets.zero, // Remove padding
                  icon: const Icon(Icons.content_copy,
                      size: 20.0), // Set icon size
                  onPressed: () {
                    // Handle add button press
                  },
                ),
              ),
            ],
          ),
          // ListView
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Column(
                  children: (song.structure as List).map((arrangementItem) {
                    return SizedBox(
                      height: 40,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(arrangementItem.section),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
