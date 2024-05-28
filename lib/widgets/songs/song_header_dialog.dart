import 'package:bandbridge/models/current_song.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class SongHeaderDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Function(Song) onSongCreated;
  final Song? song;
  final String dialogTitle;

  SongHeaderDialog({
    super.key,
    required this.onSongCreated,
    this.song,
    required this.dialogTitle,
  });

  @override
  Widget build(BuildContext context) {
    var logger = Logger(level: LoggingUtil.loggingLevel('SongHeaderDialog'));
    var currentSongProvider = Provider.of<CurrentSongProvider>(context);

    logger.d(song?.getDebugOutput('Song in SongHeaderDialog'));

    String songId = song?.id ?? '-1';
    String songTitle = song?.title ?? '';
    String artist = song?.artist ?? '';
    String key = song?.initialKey ?? 'A';
    String tempo = song?.tempo ?? '120';
    String timeSignature = song?.timeSignature ?? '4/4';

    return AlertDialog(
      title: Text(dialogTitle),
      content: Container(
        height: 500,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Song Title'),
                initialValue: songTitle,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a song title';
                  }
                  return null;
                },
                onSaved: (value) {
                  songTitle = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Artist'),
                initialValue: artist,
                validator: (value) {
                  // if (value == null || value.isEmpty) {
                  //   return 'Please enter a song artist';
                  // }
                  return null;
                },
                onSaved: (value) {
                  artist = value!;
                },
              ),
              DropdownButtonFormField<String>(
                value: key,
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
                  key = value!;
                },
              ),
              TextFormField(
                initialValue: tempo,
                decoration: const InputDecoration(labelText: 'Tempo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return 'Please enter a tempo in BPM';
                  }
                  return null;
                },
                onSaved: (value) {
                  tempo = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Time Signature'),
                value: timeSignature,
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
                  timeSignature = value!;
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
          onPressed: () {
            logger.t('Submit button pressed');
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              Song newSong = Song(
                songId: songId,
                title: songTitle,
                artist: artist,
                initialKey: key,
                tempo: tempo,
                timeSignature: timeSignature,
              );
              onSongCreated(newSong);

              logger.d(newSong.getDebugOutput('Saving song to database'));
              //SongsService().saveSongs();

              currentSongProvider.saveSong(newSong);

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
