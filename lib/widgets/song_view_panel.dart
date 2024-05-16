import 'package:bandbridge/models/current_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/songs/song_arrangement_panel.dart';
import 'package:bandbridge/widgets/songs/song_header.dart';
import 'package:bandbridge/widgets/songs/song_section_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class SongViewPanel extends StatefulWidget {
  const SongViewPanel({super.key});

  @override
  State<StatefulWidget> createState() => _SongViewPanelState();
}

class _SongViewPanelState extends State<SongViewPanel> {
  var logger = Logger(level: LoggingUtil.loggingLevel('SongViewPanel'));

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    var currentSongProvider = context.watch<CurrentSongProvider>();
    var currentSong = currentSongProvider.currentSong;

    logger.d(
        'SongViewPanel rebuilt with song: ${currentSongProvider.title} by ${currentSongProvider.artist}');

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //====================
        //====================
        // Song header panel
        SongHeader(song: currentSong),

        //====================
        //====================
        // Song panel with arrangement and chart
        Expanded(
          child: Row(
            children: [
              SongArrangementPanel(song: currentSong),
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    if ((currentSong.structure as List).isEmpty)
                      const Text('No structure defined for this song')
                    else
                      ...((currentSong.structure as List).map((section) {
                        return SongSectionPanel(section: section);
                      }).toList()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
