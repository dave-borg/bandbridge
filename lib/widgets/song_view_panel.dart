import 'package:bandbridge/models/current_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/song-editor/chord_chart_editor.dart';
import 'package:bandbridge/widgets/song-editor/lyrics_editor.dart';
import 'package:bandbridge/widgets/song-editor/song_editor.dart';
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

class _SongViewPanelState extends State<SongViewPanel>
    with SingleTickerProviderStateMixin {
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
        SongHeader(),
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: SongArrangementPanel(song: currentSong),
                    ),
                    SizedBox(
                      width: constraints.maxWidth - 150,
                      //child: SongEditor(song: currentSong),
                      child: SongEditor(song: currentSong),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
