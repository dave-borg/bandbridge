import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

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
                key: const Key('songHeaderDialog_songTitle'),
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
                key: const Key('songHeaderDialog_artist'),
                decoration: const InputDecoration(labelText: 'Artist'),
                initialValue: artist,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an artist';
                  }
                  return null;
                },
                onSaved: (value) {
                  artist = value!;
                },
              ),
              DropdownButtonFormField<String>(
                key: const Key('songHeaderDialog_songKey'),
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
                key: const Key('songHeaderDialog_tempo'),
                initialValue: tempo,
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
                  tempo = value!;
                },
              ),
              DropdownButtonFormField<String>(
                key: const Key('songHeaderDialog_timeSignature'),
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
              final box = Hive.box<Song>('songs');
              if (box.containsKey(songId)) {
                Song? existingSong = box.get(songId);
                if (existingSong != null) {
                  existingSong.title = songTitle;
                  existingSong.artist = artist;
                  existingSong.initialKey = key;
                  existingSong.tempo = tempo;
                  existingSong.timeSignature = timeSignature;
                  existingSong.save();
                  logger
                      .d(existingSong.getDebugOutput('Updated existing song'));
                  onSongCreated(existingSong);
                }
              } else {
                Song newSong = Song(
                  songId: songId,
                  title: songTitle,
                  artist: artist,
                  initialKey: key,
                  tempo: tempo,
                  timeSignature: timeSignature,
                );
                box.put(newSong.id, newSong);
                logger.d(newSong.getDebugOutput('Added new song'));
                logger.d("Added Song key: ${newSong.id}");
                onSongCreated(newSong);
              }
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
