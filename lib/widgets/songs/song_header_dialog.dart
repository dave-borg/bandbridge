import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SongHeaderDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Function(Song) onSongCreated;
  final Song song;
  final String dialogTitle;

  SongHeaderDialog({
    super.key,
    required this.onSongCreated,
    required this.song,
    required this.dialogTitle,
  });

  @override
  Widget build(BuildContext context) {
    var logger = Logger(level: LoggingUtil.loggingLevel('SongHeaderDialog'));

    logger.d(song.getDebugOutput('Song in SongHeaderDialog'));

    return AlertDialog(
      title: Text(dialogTitle),
      // ignore: sized_box_for_whitespace
      content: Container(
        height: 500,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                key: const Key('songHeaderDialog_songTitle'),
                decoration: const InputDecoration(labelText: 'Song Title'),
                initialValue: song.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a song title';
                  }
                  return null;
                },
                onSaved: (value) {
                  song.title = value!;
                },
              ),
              TextFormField(
                key: const Key('songHeaderDialog_artist'),
                decoration: const InputDecoration(labelText: 'Artist'),
                initialValue: song.artist,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an artist';
                  }
                  return null;
                },
                onSaved: (value) {
                  song.artist = value!;
                },
              ),
              DropdownButtonFormField<String>(
                key: const Key('songHeaderDialog_songKey'),
                value: song.initialKey,
                decoration: const InputDecoration(labelText: 'Key'),
                items: <String>[
                  'A',
                  'A♯/B♭',
                  'B',
                  'C',
                  'C♯/D♭',
                  'D',
                  'D♯/E♭',
                  'E',
                  'F',
                  'F♯/G♭',
                  'G',
                  'G♯/A♭',
                  'Am',
                  'A♯m/B♭m',
                  'Bm',
                  'Cm',
                  'C♯m/D♭m',
                  'Dm',
                  'D♯m/E♭m',
                  'Em',
                  'Fm',
                  'F♯m/G♭m',
                  'Gm',
                  'G♯m/A♭m'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  song.initialKey = value!;
                },
              ),
              TextFormField(
                key: const Key('songHeaderDialog_tempo'),
                initialValue: song.tempo,
                decoration: const InputDecoration(labelText: 'Tempo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      num.tryParse(value) == null) {
                    return 'Please enter a tempo in BPM';
                  }
                  return null;
                },
                onSaved: (value) {
                  song.tempo = value!;
                },
              ),
              DropdownButtonFormField<String>(
                key: const Key('songHeaderDialog_timeSignature'),
                decoration: const InputDecoration(labelText: 'Time Signature'),
                value: song.timeSignature,
                items: <String>[
                  '4/4',
                  '3/4',
                  '6/8',
                  '2/4',
                  '3/8',
                  '5/4',
                  '7/8',
                  '9/8',
                  '12/8'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  song.timeSignature = value!;
                },
              ),
            ],
          ),
        ),
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

              onSongCreated(song);
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
