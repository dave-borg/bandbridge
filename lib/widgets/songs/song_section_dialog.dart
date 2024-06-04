import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SongArrangementDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  var onSectionCreated;
  Song song;
  String dialogTitle;

  SongArrangementDialog({
    super.key,
    required this.onSectionCreated,
    required this.song,
    required this.dialogTitle,
  });

  Section newSection = Section();

  @override
  Widget build(BuildContext context) {
    var logger = Logger(level: LoggingUtil.loggingLevel('SongHeaderDialog'));
    return AlertDialog(
      title: Text(dialogTitle),
      content: Container(
        height: 250,
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  key: const Key('songSectionDialog_sectionTitle'),
                  decoration: const InputDecoration(labelText: 'Section Title'),
                  initialValue: newSection.section,
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
              song.addSection(newSection);
              onSectionCreated(song);
              Navigator.of(context).pop();
            } else {
              logger.d('Form is not valid');
            }
          },
        ),
      ],
    );
  }
}
