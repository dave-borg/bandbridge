import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/widgets/songs/audio/track_widget.dart';
import 'package:flutter/material.dart';

class AudioEditor extends StatefulWidget {
  const AudioEditor({Key? key, required this.song}) : super(key: key);

  final Song song;

  @override
  // ignore: library_private_types_in_public_api
  _AudioEditorState createState() => _AudioEditorState();
}

class _AudioEditorState extends State<AudioEditor> {
  @override
  Widget build(Object context) {
    return Column(
          children: [
    const Row(
      children: [
        IconButton(
          tooltip: "Settings",
          icon: Icon(Icons.settings),
          onPressed: null,
        ),
        IconButton(
          tooltip: "Play All Tracks",
          icon: Icon(Icons.play_arrow_outlined),
          onPressed: null,
        ),
      ],
    ),
    TrackWidget(trackName: "Backing Track"),
    TrackWidget(trackName: "Guide"),
    const SizedBox(
      width: double.infinity,
      child: IconButton(
        icon: Icon(Icons.add),
        color: Colors.blue,
        onPressed: null,
      ),
    ),
          ],
        );
  }
}
