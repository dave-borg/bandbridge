import 'package:bandbridge/models/current_song.dart';
import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/songs/song_section_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SongArrangementPanel extends StatefulWidget {
  SongArrangementPanel({
    super.key,
    required this.song,
  });

  var logger = Logger(level: LoggingUtil.loggingLevel('SongArrangementPanel'));
  Song song;

  @override
  // ignore: library_private_types_in_public_api
  _SongArrangementPanelState createState() => _SongArrangementPanelState();
}

class _SongArrangementPanelState extends State<SongArrangementPanel> {
  var currentSongProvider;
  int? selectedSectionIndex;

  @override
  State<StatefulWidget> createState() {
    return _SongArrangementPanelState();
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentSongProvider = Provider.of<CurrentSongProvider>(context);

    return SizedBox(
      width: 150,
      child: SingleChildScrollView(
        child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                      onPressed: () async {
                        final Section result = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ChangeNotifierProvider<
                                CurrentSongProvider>.value(
                              value: currentSongProvider,
                              child: SongArrangementDialog(
                                dialogTitle: 'Add Section',
                                song: widget.song,
                                sectionIndex: -1,
                                onSectionCreated: (newSection) {
                                  setState(() {});
                                },
                              ),
                            );
                          },
                        );

                        if (result != null) {
                          // Add the section
                          setState(() {
                            // Assuming sections is your list of sections
                            widget.song.addStructure(result);
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 30.0, // Your desired width
                    child: IconButton(
                      padding: EdgeInsets.zero, // Remove padding
                      icon: const Icon(Icons.edit, size: 20.0), // Set icon size
                      onPressed: selectedSectionIndex != null
                          ? () async {
                              // Only enable button if an item is selected
                              final Section result = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // Assuming currentSong is your current song
                                  // and SongSectionDialog takes a song and an index
                                  return SongArrangementDialog(
                                    dialogTitle: 'Edit Section',
                                    song: widget.song,
                                    sectionIndex: selectedSectionIndex!,
                                    onSectionCreated: (updatedSection) {
                                      setState(() {});
                                    },
                                  );
                                },
                              );

                              if (result != null) {
                                // Update the section
                                setState(() {
                                  // Assuming sections is your list of sections
                                  widget.song.structure[selectedSectionIndex!] =
                                      result;
                                });
                              }
                            }
                          : null, // Disable button if no item is selected
                    ),
                  ),
                  SizedBox(
                    width: 30.0, // Your desired width
                    child: IconButton(
                      padding: EdgeInsets.zero, // Remove padding
                      icon:
                          const Icon(Icons.delete, size: 20.0), // Set icon size
                      onPressed: selectedSectionIndex != null
                          ? () async {
                              // Only enable button if an item is selected
                              final confirm = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm'),
                                    content: const Text(
                                        'Are you sure you want to delete this section?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm) {
                                // Delete the section
                                setState(() {
                                  // Assuming sections is your list of sections
                                  widget.song.structure
                                      .removeAt(selectedSectionIndex!);
                                  selectedSectionIndex =
                                      null; // Reset selection
                                });
                              }
                            }
                          : null, // Disable button if no item is selected
                    ),
                  ),
                ],
              ),
              // ListView
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.song.structure.length,
                itemBuilder: (BuildContext context, int index) {
                  final section = widget.song.structure[index];
                  return ListTile(
                    title: Text(section.section),
                    selected: selectedSectionIndex == index,
                    onTap: () {
                      setState(() {
                        selectedSectionIndex = index;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addSection(updatedSong) {
    updatedSong.save();
    setState(() {
      // Add your code here
    });
  }
}
