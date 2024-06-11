import 'package:bandbridge/models/mdl_chord.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/music_theory/diatonic_chords.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class BarDialog extends StatelessWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('BarDialog'));
  List<Chord> bar;
  late Song song;
  String dialogTitle;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  BarDialog({
    super.key,
    required this.song,
    required this.bar,
    required this.dialogTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(dialogTitle),
      content: Column(
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.black, // Color of the border
                      width: 5.0, // Thickness of the border
                      style: BorderStyle.solid, // Style of the border
                    ),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    bar.isEmpty ? " / " : bar[0].name,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 100,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    bar.isEmpty ? " / " : bar[1].name,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 100,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    bar.isEmpty ? " / " : bar[2].name,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.black, // Color of the border
                      width: 5.0, // Thickness of the border
                      style: BorderStyle.solid, // Style of the border
                    ),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    bar.isEmpty ? " / " : bar[3].name,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              children: List.generate(7, (index) {
                return Container(
                  width: 75,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your button logic here
                    },
                    child: Text(DiatonicChords.getDiatonicChord(
                            song.initialKey, song.initialKeyType, index)
                        .name),
                  ),
                );
              }),
            ),
          ),
        ],
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

              //onSongCreated(song);
              // }
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
