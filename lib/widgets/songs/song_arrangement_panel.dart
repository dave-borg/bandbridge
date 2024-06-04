import 'package:bandbridge/models/current_song.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/songs/song_section_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SongArrangementPanel extends StatefulWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('SongArrangementPanel'));

  Song song;

  SongArrangementPanel({
    super.key,
    required this.song,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SongArrangementPanelState createState() => _SongArrangementPanelState();
}

class _SongArrangementPanelState extends State<SongArrangementPanel> {
  var currentSongProvider;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentSongProvider = Provider.of<CurrentSongProvider>(context);

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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ChangeNotifierProvider<
                            CurrentSongProvider>.value(
                          value: currentSongProvider,
                          child: SongArrangementDialog(
                            key: const Key('dlg_songList_songHeaderDialog'),
                            dialogTitle: 'Add Song',
                            song: widget.song,
                            onSectionCreated: (updatedSong) {
                              setState(() {
                                _addSection(updatedSong);
                              });
                            },
                          ),
                        );
                      },
                    );
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
                  children:
                      (widget.song.structure as List).map((arrangementItem) {
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

  void _addSection(updatedSong) {
    updatedSong.save();
    setState(() {
      // Add your code here
    });
  }

  @override
  State<StatefulWidget> createState() {
    return _SongArrangementPanelState();
  }
}
