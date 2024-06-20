import 'package:bandbridge/models/song_provider.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/songs/song-editor/song_editor_tabs.dart';
import 'package:bandbridge/widgets/songs/sections_list.dart';
import 'package:bandbridge/widgets/songs/song_header.dart';
import 'package:flutter/material.dart';
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
    var currentSongProvider = context.watch<SongProvider>();
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
          child: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 140,
                        height: double.infinity,
                        child: SectionsList(song: currentSong),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth - 150,
                      child: SongEditorTabs(song: currentSong),
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
