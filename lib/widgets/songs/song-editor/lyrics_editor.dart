import 'package:bandbridge/models/mdl_beat.dart';
import 'package:bandbridge/models/mdl_bar.dart';
import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/lyrics/lyrics_dialog.dart';
import 'package:flutter/material.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:logger/logger.dart';

class LyricsEditor extends StatefulWidget {
  final Song song;
  final int? sectionIndex;
  List<Lyric> lyrics = [];

  LyricsEditor({super.key, required this.song, this.sectionIndex}) {
    lyrics = song.unsynchronisedLyrics;
  }

  @override
  // ignore: library_private_types_in_public_api
  _LyricsEditorState createState() => _LyricsEditorState();
}

class _LyricsEditorState extends State<LyricsEditor> {
  var logger = Logger(level: LoggingUtil.loggingLevel('LyricsEditor'));

  late List<Lyric> lyrics;

  @override
  void initState() {
    super.initState();
    lyrics = widget.lyrics;
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      final lyric = lyrics.removeAt(oldIndex);
      lyrics.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, lyric);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final String? textLyrics = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return const LyricsDialog(); // Your custom dialog widget
                    },
                  );

                  // Check if the dialog was dismissed with a result
                  if (textLyrics != null) {
                    List<String> lines = textLyrics.split('\n');
                    List<Lyric> inputLyrics = [];

                    for (String line in lines) {
                      inputLyrics.add(Lyric(text: line, beats: ''));
                    }

                    setState(() {
                      widget.song.unsynchronisedLyrics = inputLyrics;
                      widget.lyrics = inputLyrics;
                      logger.d(widget.song
                          .getDebugOutput('Added unsynchronised lyrics'));
                      widget.song.save();
                    });
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Add your onPressed code here.
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Add your onPressed code here.
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.song.sections.length,
            itemBuilder: (context, i) {
              //================================================================================================
              //Only show the section if the sectionIndex is null or matches the current index
              if (widget.sectionIndex != null && widget.sectionIndex != i) {
                return Container(); // Return an empty container if sectionIndex is not null and does not match the current index
              }

              //================================================================================================
              //Show the sections' header and lyrics
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (i == 0 && widget.song.unsynchronisedLyrics.isNotEmpty)
                    DragTarget<Lyric>(
                      onWillAcceptWithDetails: (data) => true,
                      onAcceptWithDetails: (data) {
                        onReorder(lyrics.indexOf(data as Lyric), i);
                      },
                      builder: (context, candidateData, rejectedData) =>
                          Draggable<Lyric>(
                        data: lyrics[i],
                        feedback: Material(
                          elevation: 4.0,
                          child: lyricLine(lyrics[i].text, isFeedback: true),
                        ),
                        childWhenDragging: Container(),
                        child: lyricLine(lyrics[i].text),
                      ),
                    ),
                  if (i == lyrics.length - 1)
                    DragTarget<Lyric>(
                      onWillAcceptWithDetails: (data) => true,
                      onAcceptWithDetails: (data) {
                        onReorder(lyrics.indexOf(data as Lyric), lyrics.length);
                      },
                      builder: (context, candidateData, rejectedData) =>
                          Container(
                              height:
                                  20), // Placeholder for dropping at the end
                    ),
                  Draggable(
                    data: widget.song.sections[i].section,
                    feedback: Material(
                      // The feedback widget is what is shown to the user when they are dragging the widget.
                      elevation: 4.0,
                      // The feedback widget is what is shown to the user when they are dragging the widget.
                      child: Container(
                        width: 200, // Specify the width of the feedback widget.
                        height:
                            50, // Specify the height of the feedback widget.
                        margin: const EdgeInsets.only(top: 16.0),
                        color: Colors.grey[400],
                        child: Text(
                          widget.song.sections[i].section,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ), // You can change the color of the feedback widget.
                      ),
                    ),
                    childWhenDragging:
                        Container(), // This is the data that will be passed to the DragTarget.
                    child: Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        widget.song.sections[i].section,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ), // This is what is shown in the original place of the draggable widget when it's being dragged.
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: extractLyrics(widget.song.sections[i]).length,
                    itemBuilder: (context, j) {
                      return Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          extractLyrics(widget.song.sections[i])[j].text,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  List<Lyric> extractLyrics(Section section) {
    List<Lyric> lyrics = [];
    for (Bar bar in section.bars!) {
      for (Beat beat in bar.beats) {
        if (beat.lyric != null) {
          lyrics.add(beat.lyric!);
        }
      }
    }
    return lyrics;
  }

  Widget lyricLine(String text, {bool isFeedback = false}) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(8.0),
        color: isFeedback ? Colors.grey[350] : Colors.transparent,
        child: Text(text, style: const TextStyle(fontSize: 16)),
      );
}
