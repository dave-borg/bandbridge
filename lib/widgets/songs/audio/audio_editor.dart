import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/songs/audio/track_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AudioEditor extends StatefulWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('AudioEditor'));

  AudioEditor({super.key, required this.song});

  final Song song;

  @override
  // ignore: library_private_types_in_public_api
  _AudioEditorState createState() => _AudioEditorState();
}

class _AudioEditorState extends State<AudioEditor> {
  List<TrackWidget> tracks = []; //change this to come from the song object

  void addTrack() {
    setState(() {
      tracks.add(TrackWidget(trackName: "Track ${tracks.length + 1}"));
    });
  }

  void playAllTracks() {
    widget.logger.d("Attempting to play all tracks");
    for (var track in tracks) {
      widget.logger.d("Playing track: ${track.trackName}");
      track.play();
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize your tracks list based on the song object or however you prefer
    tracks.add(TrackWidget(trackName: "Track 1")); // Example initialization
  }

  @override
  Widget build(Object context) {
    return Column(
      children: [
        Row(
          children: [
            const IconButton(
              tooltip: "Settings",
              icon: Icon(Icons.settings),
              onPressed: null,
            ),
            IconButton(
              tooltip: "Play All Tracks",
              icon: const Icon(Icons.play_arrow_outlined),
              onPressed: playAllTracks,
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...tracks, // Your list of TrackWidgets
                SizedBox(
                  width: double.infinity,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.blue,
                    onPressed: addTrack,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
