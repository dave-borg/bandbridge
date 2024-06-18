import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/models/song_provider.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/lyrics/lyrics_dialog.dart';
import 'package:bandbridge/widgets/songs/song-editor/lyrics_preview_struct.dart';
import 'package:flutter/material.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LyricsEditor extends StatefulWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('LyricsEditor'));

  final Song song;
  final int? sectionIndex;
  List<Lyric> lyricsList = [];
  late LyricsStruct previewSections;

  LyricsEditor({super.key, required this.song, this.sectionIndex}) {
    lyricsList = song.unsynchronisedLyrics;
    previewSections = LyricsStruct(song);
    logger.d("previewSections: $previewSections");
  }

  @override
  // ignore: library_private_types_in_public_api
  _LyricsEditorState createState() => _LyricsEditorState();
}

class _LyricsEditorState extends State<LyricsEditor> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<PreviewSection> structures =
        widget.previewSections.getPreviewSections();

    final songProvider = Provider.of<SongProvider>(context);
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    AppBar(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () async {
                              final String? textLyrics =
                                  await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return const LyricsDialog(); // Your custom dialog widget
                                },
                              );

                              // Check if the dialog was dismissed with a result
                              if (textLyrics != null) {
                                List<String> lines = textLyrics
                                    .split('\n')
                                    .map((line) => line.trim())
                                    .toList();
                                List<Lyric> inputLyrics = [];

                                for (String line in lines) {
                                  if (line.isNotEmpty) {
                                    inputLyrics
                                        .add(Lyric(text: line, beats: ''));
                                  }
                                }

                                setState(() {
                                  widget.song.unsynchronisedLyrics =
                                      inputLyrics;
                                  widget.lyricsList = inputLyrics;
                                  widget.logger.d(widget.song.getDebugOutput(
                                      'Added unsynchronised lyrics'));
                                  songProvider.saveSong(widget.song);
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
                              showDialog(
                                context:
                                    context, // You need to pass the BuildContext
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm'),
                                    content: const Text(
                                        'Are you sure you want to delete all lyrics?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Dismiss the dialog
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.song.deleteAllLyrics();
                                            widget.lyricsList = [];
                                            songProvider.saveSong(widget.song);
                                          });
                                          Navigator.of(context)
                                              .pop(); // Dismiss the dialog after performing the action
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: structures.length,
                          itemBuilder: (context, index) {
                            final structure = structures[index];

                            if (structure.lyrics.isEmpty) {
                              // Skip this section by rendering an empty widget
                              return const SizedBox.shrink();
                            }

                            return Column(children: <Widget>[
                              Text(structure.thisSection?.section ?? ''),
                              ...structure.lyrics
                                  .map((lyric) => DragTarget<Section>(
                                        onWillAcceptWithDetails: (data) =>
                                            true, // Decide whether to accept the data
                                        onAcceptWithDetails: (droppedObject) {
                                          widget.logger.d(
                                              "Dropped data: ${droppedObject.data.section}\n\nDropped data: ${lyric.text}");
                                          setState(() {
                                            widget.previewSections.setSection(
                                                section: droppedObject.data,
                                                lyric: lyric);
                                            widget.song.save();
                                          });
                                        },
                                        builder: (context, candidateData,
                                            rejectedData) {
                                          Color textColor =
                                              candidateData.isNotEmpty
                                                  ? Colors.blue
                                                  : Colors.black;
                                          return Container(
                                            // Optional: Add padding, decoration, etc. if needed
                                            padding: const EdgeInsets.all(4.0),
                                            // decoration: BoxDecoration(
                                            //   border: Border.all(
                                            //       color: Colors
                                            //           .grey), // Add border with desired color
                                            //   borderRadius: BorderRadius.circular(
                                            //       4.0), // Optional: if you want rounded corners
                                            // ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(lyric.text,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color:
                                                          textColor) // Ensure text is left-aligned
                                                  ),
                                            ),
                                          );
                                        },
                                      )),
                            ]);
                          }),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.grey[200],
                  child: ListView.builder(
                    itemCount: widget.song.sections.length,
                    itemBuilder: (context, i) {
                      // This index is for a section
                      final section = widget.song.sections[i];
                      return ListTile(
                        title: Draggable(
                          feedback: Text(
                            section.section,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          childWhenDragging: Container(),
                          data: section,
                          child: Text(
                            section.section,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
