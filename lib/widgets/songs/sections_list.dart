import 'package:bandbridge/models/song_provider.dart';
import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/songs/song_section_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// SongArrangementPanel
///
/// This widget displays a list of sections for a song. It allows the user to add, edit, and delete sections. It contains the
/// list of song sections for CRUD operations.
// ignore: must_be_immutable
class SectionsList extends StatefulWidget {
  SectionsList({
    super.key,
    required this.song,
  });

  var logger = Logger(level: LoggingUtil.loggingLevel('SongArrangementPanel'));
  Song song;

  @override
  // ignore: library_private_types_in_public_api
  _SectionsListState createState() => _SectionsListState();
}

class _SectionsListState extends State<SectionsList> {
  late SongProvider currentSongProvider;
  int? selectedSectionIndex;

  State<StatefulWidget> createState() {
    return _SectionsListState();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentSongProvider = Provider.of<SongProvider>(context);

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
                    
                    
                    
                    //================================================================
                    //Add Section button
                    child: IconButton(
                      key: const Key('songList_btnAddSection'),
                      padding: EdgeInsets.zero, // Remove padding
                      icon: const Icon(Icons.add, size: 20.0), // Set icon size
                      onPressed: () async {
                        final Section? result = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ChangeNotifierProvider<SongProvider>.value(
                              value: currentSongProvider,
                              child: SongArrangementDialog(
                                dialogTitle: 'Add Section',
                                song: widget.song,
                                sectionIndex: -1,
                                onSectionCreated: (newSection) {
                                  //setState(() {});
                                },
                              ),
                            );
                          },
                        );

                        widget.logger.d("result.section: ${result?.section}");

                        if (result != null) {
                          setState(() {
                            widget.song.addStructure(result);
                            currentSongProvider.saveSong(widget.song);
                          });
                        }
                      },
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
                                  widget.song.sections.removeAt(selectedSectionIndex!);
                                  currentSongProvider.saveSong(widget.song);
                                  selectedSectionIndex = null; 
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
                itemCount: widget.song.sections.length,
                itemBuilder: (BuildContext context, int index) {
                  final section = widget.song.sections[index];
                  return ListTile(
                    key: ValueKey("song_section_$index"),
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
}
