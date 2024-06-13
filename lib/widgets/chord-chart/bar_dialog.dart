import 'dart:ffi';

import 'package:bandbridge/models/mdl_bar.dart';
import 'package:bandbridge/models/mdl_chord.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/music_theory/chord_modifiers.dart';
import 'package:bandbridge/music_theory/diatonic_chords.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/chord-chart/chord_container.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class BarDialog extends StatefulWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('BarDialog'));
  final Bar bar;
  Song song;
  String dialogTitle;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  BarDialog({
    super.key,
    required this.song,
    required this.dialogTitle,
    required this.bar,
  });

  @override
  _BarDialogState createState() => _BarDialogState();
}

class _BarDialogState extends State<BarDialog> {
  int? _selectedContainerIndex = -1;
  final TextEditingController _chordNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var selectedChord;
    if (_selectedContainerIndex != -1) {
      selectedChord = widget.bar.beats[_selectedContainerIndex!].chord;
    } 
    return AlertDialog(
      title: Text(widget.dialogTitle),
      content: Column(
        children: [
          //====================================================================================
          //Renders the bar with 4 beats per bar
          Row(
            children: [
              for (int i = 0;
                  i < widget.bar.beats.length;
                  i++) // Assuming you want to make containers for bar[2] and bar[3] selectable
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedContainerIndex = i;
                        if (_selectedContainerIndex != null) {
                          selectedChord = widget
                                  .bar
                                  .beats[_selectedContainerIndex!]
                                  .chord;
                          _chordNameController.text = selectedChord
                                  ?.renderFullChord() ??
                              '';
                        }
                      });
                    },
                    child: Container(
                      // width: 100,
                      height: 100,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: i == 0
                            ? const Border(
                                left: BorderSide(
                                  color: Colors.black,
                                  width: 5.0,
                                  style: BorderStyle.solid,
                                ),
                              )
                            : i == widget.bar.beats.length - 1
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
                        child: widget.bar.beats[i].chord == null
                            ? const Text(
                                " / ",
                                style: TextStyle(fontSize: 36),
                              )
                            : ChordContainer(chord: widget.bar.beats[i].chord!),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          //====================================================================================
          //Renders the diatonic chords for the initial key
          const Row(
            children: [
              Text('Diatonic Chords'),
            ],
          ),

          Row(
            children: List.generate(7, (index) {
              var thisChord = DiatonicChords.getDiatonicChord(
                  widget.song.initialKey, widget.song.initialKeyType, index);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 55,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _selectedContainerIndex == -1
                        ? null
                        : () {
                            setState(() {
                              widget.bar.beats[_selectedContainerIndex!].chord =
                                  thisChord;
                              _chordNameController.text = '${thisChord.rootNote}${thisChord.renderElements()}';
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(4),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Reduce corner radius
                      ),
                    ),
                    child: Text('${thisChord.rootNote}${thisChord.renderElements()}'),
                  ),
                ),
              );
            }),
          ),

          //====================================================================================
          //Form for entering chord name
          Form(
            key: widget._formKey,
            child: TextFormField(
              key: const Key('bar_dialog_chord_name'),
              controller: _chordNameController,
              decoration: const InputDecoration(
                labelText: 'Chord Name',
              ),
              onChanged: (value) {
                setState(() {
                  widget.logger.d("Chord to be added: $value");
                  widget.bar.beats[_selectedContainerIndex!].chord =
                      Chord(rootNote: value, beats: '1');
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Chord';
                }
                return null;
              },
            ),
          ),

          //====================================================================================
          //Buttons for modifiers
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 55,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedContainerIndex == -1
                      ? null
                      : () {
                          setState(() {
                            if (selectedChord?.chordQuality == ChordModifiers.MAJOR) {
                              selectedChord?.chordQuality = null;
                            } else {
                              selectedChord?.chordQuality = ChordModifiers.MAJOR;
                            }
                            
                            _chordNameController.text = selectedChord?.renderFullChord();
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Reduce corner radius
                    ),
                  ),
                  child: const Text("M"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 55,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedContainerIndex == -1
                      ? null
                      : () {
                          setState(() {
                            if (selectedChord?.chordQuality == ChordModifiers.MINOR) {
                              selectedChord?.chordQuality = null;
                            } else {
                              selectedChord?.chordQuality = ChordModifiers.MINOR;
                            }
                            _chordNameController.text = selectedChord?.renderFullChord();
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Reduce corner radius
                    ),
                  ),
                  child: Text(ChordModifiers.render(ChordModifiers.MINOR)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 55,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedContainerIndex == -1
                      ? null
                      : () {
                          setState(() {
                            if (selectedChord?.chordExtension == ChordModifiers.MINOR_SEVENTH) {
                              selectedChord?.chordExtension = null;
                            } else {
                              selectedChord?.chordExtension = ChordModifiers.MINOR_SEVENTH;
                            }
                            _chordNameController.text = selectedChord?.renderFullChord();
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Reduce corner radius
                    ),
                  ),
                  child: Text(ChordModifiers.render(ChordModifiers.MINOR_SEVENTH)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 55,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedContainerIndex == -1
                      ? null
                      : () {
                          setState(() {
                            if (selectedChord?.chordExtension == ChordModifiers.NINTH) {
                              selectedChord?.chordExtension = null;
                            } else {
                              selectedChord?.chordExtension = ChordModifiers.NINTH;
                            }
                            _chordNameController.text = selectedChord?.renderFullChord();
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Reduce corner radius
                    ),
                  ),
                  child: Text(ChordModifiers.render(ChordModifiers.NINTH)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 55,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedContainerIndex == -1
                      ? null
                      : () {
                          setState(() {
                            if (selectedChord?.chordExtension == ChordModifiers.ELEVENTH) {
                              selectedChord?.chordExtension = null;
                            } else {
                              selectedChord?.chordExtension = ChordModifiers.ELEVENTH;
                            }
                            _chordNameController.text = selectedChord?.renderFullChord();
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Reduce corner radius
                    ),
                  ),
                  child: Text(ChordModifiers.render(ChordModifiers.ELEVENTH)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 55,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedContainerIndex == -1
                      ? null
                      : () {
                          setState(() {
                            if (selectedChord?.chordExtension == ChordModifiers.THIRTEENTH) {
                              selectedChord?.chordExtension = null;
                            } else {
                              selectedChord?.chordExtension = ChordModifiers.THIRTEENTH;
                            }
                            _chordNameController.text = selectedChord?.renderFullChord();
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Reduce corner radius
                    ),
                  ),
                  child: Text(ChordModifiers.render(ChordModifiers.THIRTEENTH)),
                ),
              ),
            ),
          ]),
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 55,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedContainerIndex == -1
                      ? null
                      : () {
                          setState(() {
                            if (selectedChord?.chordExtension == ChordModifiers.MAJOR_SEVENTH) {
                              selectedChord?.chordExtension = null;
                            } else {
                              selectedChord?.chordExtension = ChordModifiers.MAJOR_SEVENTH;
                            }
                            _chordNameController.text = selectedChord?.renderFullChord();
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Reduce corner radius
                    ),
                  ),
                  child: Text(ChordModifiers.render(ChordModifiers.MAJOR_SEVENTH)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 55,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedContainerIndex == -1
                      ? null
                      : () {
                          setState(() {
                            if (selectedChord?.chordQuality == ChordModifiers.DIMINISHED) {
                              selectedChord?.chordQuality = null;
                            } else {
                              selectedChord?.chordQuality = ChordModifiers.DIMINISHED;
                            }
                            _chordNameController.text = selectedChord?.renderFullChord();
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Reduce corner radius
                    ),
                  ),
                  child: Text(ChordModifiers.render(ChordModifiers.DIMINISHED)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 55,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedContainerIndex == -1
                      ? null
                      : () {
                          setState(() {
                            if (selectedChord?.chordQuality == ChordModifiers.HALF_DIMINISHED) {
                              selectedChord?.chordQuality = null;
                            } else {
                              selectedChord?.chordQuality = ChordModifiers.HALF_DIMINISHED;
                            }
                            _chordNameController.text = selectedChord?.renderFullChord();
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Reduce corner radius
                    ),
                  ),
                  child: Text(ChordModifiers.render(ChordModifiers.HALF_DIMINISHED)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 55,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedContainerIndex == -1
                      ? null
                      : () {
                          setState(() {
                            if (selectedChord?.chordQuality == ChordModifiers.AUGMENTED) {
                              selectedChord?.chordQuality = null;
                            } else {
                              selectedChord?.chordQuality = ChordModifiers.AUGMENTED;
                            }
                            _chordNameController.text = selectedChord?.renderFullChord();
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Reduce corner radius
                    ),
                  ),
                  child: Text(ChordModifiers.render(ChordModifiers.AUGMENTED)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 55,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedContainerIndex == -1
                      ? null
                      : () {
                          setState(() {
                            if (selectedChord?.chordExtension == ChordModifiers.SUSPENDED) {
                              selectedChord?.chordExtension = null;
                            } else {
                              selectedChord?.chordExtension = ChordModifiers.SUSPENDED;
                            }
                            _chordNameController.text = selectedChord?.renderFullChord();
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Reduce corner radius
                    ),
                  ),
                  child: Text(ChordModifiers.render(ChordModifiers.SUSPENDED)),
                ),
              ),
            ),
          ]),
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
              Navigator.of(context).pop(widget.bar);
            } else {
              widget.logger.d('Form is not valid');
            }
          },
        ),
      ],
    );
  }
}
