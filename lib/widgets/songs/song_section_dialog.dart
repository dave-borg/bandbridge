import 'package:bandbridge/models/mdl_bar.dart';
import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class SongArrangementDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  dynamic onSectionCreated;
  Song song;
  String dialogTitle;
  int sectionIndex;

  SongArrangementDialog({
    super.key,
    required this.onSectionCreated,
    required this.song,
    required this.dialogTitle,
    required this.sectionIndex,
  });

  Section newSection = Section();

  @override
  Widget build(BuildContext context) {
    var logger = Logger(level: LoggingUtil.loggingLevel('SongHeaderDialog'));
    return AlertDialog(
      title: Text(dialogTitle),
      // ignore: sized_box_for_whitespace
      content: Container(
        height: 250,
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  key: const Key('songSectionDialog_sectionTitle'),
                  decoration: const InputDecoration(labelText: 'Section Title'),
                  initialValue: sectionIndex == -1
                      ? ""
                      : song.sections[sectionIndex].section,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a section title\n(eg. Verse, Chorus)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    newSection.section = value!;
                  },
                ),
                sectionIndex ==
                        -1 //section is new. Hide if the section is being edited - only offer the name to be edited
                    ? DropdownButtonFormField<Section>(
                        key: const Key('songSectionDialog_sectionDropdown'),
                        decoration: const InputDecoration(
                            labelText: 'Duplicate from...'),
                        value: sectionIndex == -1
                            ? null
                            : song.sections[sectionIndex],
                        items: <DropdownMenuItem<Section>>[
                          const DropdownMenuItem<Section>(
                            value: null,
                            child: Text('None'),
                          ),
                          ...song.sections.map((section) {
                            return DropdownMenuItem<Section>(
                              value: section,
                              child: Text(section.section),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          // newSection.lyrics =
                        },
                        onSaved: (value) {
                          if (value != null) {
                            newSection.bars = value.bars!.map((bar) => bar.copy()).cast<Bar>().toList();
                          }
                        },
                      )
                    : Container(), // return an empty Container when sectionIndex is not null
              ],
            )),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Submit'),
          onPressed: () async {
            logger.t('Submit button pressed');
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              // Return the new section instead of adding it to the song
              Navigator.of(context).pop(newSection);
            } else {
              logger.d('Form is not valid');
            }
          },
        ),
      ],
    );
  }
}
