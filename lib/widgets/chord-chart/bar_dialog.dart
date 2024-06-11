import 'package:bandbridge/models/mdl_chord.dart';
import 'package:bandbridge/models/mdl_song.dart';
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
    required Song song,
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
                child: Text('Bar: '),
              ),
              Container(
                width: 100,
                child: Text('Bar: '),
              ),
              Container(
                width: 100,
                child: Text('Bar: '),
              ),
              Container(
                width: 100,
                child: Text('Bar: '),
              ),
            ],
          ),
          Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    key: const Key('barDialog_chords'),
                    decoration: const InputDecoration(labelText: 'Chords'),
                    initialValue: bar.map((e) => e.name).join(' '),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter chords';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      bar = value!
                          .split(' ')
                          .map((e) => Chord(name: e, beats: '1'))
                          .toList();
                    },
                  ),
                ],
              ),
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
