import 'package:bandbridge/models/mdl_bar.dart';
import 'package:bandbridge/models/mdl_chord.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/music_theory/diatonic_chords.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/chord-chart/chord_container.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class BarDialog extends StatefulWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('BarDialog'));
  late List<Chord> bar;
  late Song song;
  String dialogTitle;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  BarDialog({
    super.key,
    required Song song,
    required Bar bar,
    required this.dialogTitle,
  });

  @override
  _BarDialogState createState() => _BarDialogState();
}

class _BarDialogState extends State<BarDialog> {
  int? _selectedContainerIndex;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.dialogTitle),
      content: Column(
        children: [
          //====================================================================================
          //Renders the bar with 4 beats per bar
          Row(
            children: [
              for (int i = 0;
                  i <= 3;
                  i++) // Assuming you want to make containers for bar[2] and bar[3] selectable
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedContainerIndex = i;
                      });
                    },
                    child: Container(
                      // width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: i == 0
                            ? const Border(
                                left: BorderSide(
                                  color: Colors.black,
                                  width: 5.0,
                                  style: BorderStyle.solid,
                                ),
                              )
                            : i == 3
                                ? const Border(
                                    right: BorderSide(
                                      color: Colors.black,
                                      width: 5.0,
                                      style: BorderStyle.solid,
                                    ),
                                  )
                                : null,
                        color: _selectedContainerIndex == i
                            ? Colors.blue
                            : Colors
                                .transparent, // Highlight selected container
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: widget.bar.isEmpty
                            ? const Text(
                                " / ",
                                style: TextStyle(fontSize: 36),
                              )
                            : ChordContainer(chord: widget.bar[i]),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          //====================================================================================
          //Renders the diatonic chords for the initial key
          Container(
            child: Row(
              children: List.generate(7, (index) {
                var thisChord = DiatonicChords.getDiatonicChord(
                    widget.song.initialKey, widget.song.initialKeyType, index);
                return Container(
                  width: 75,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.bar[_selectedContainerIndex!] = thisChord;
                      });
                    },
                    child: Text(thisChord.name),
                  ),
                );
              }),
            ),
          ),
        ],
      ),

      //====================================================================================
      //Cancel and Submit btns
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Done'),
          onPressed: () async {
            widget.logger.t('Submit button pressed');
            if (widget._formKey.currentState?.validate() ?? false) {
              widget._formKey.currentState?.save();

              //onSongCreated(widget.song);
              // }
              Navigator.of(context).pop();
            } else {
              widget.logger.d('Form is not valid');
            }
          },
        ),
      ],
    );
  }
}
