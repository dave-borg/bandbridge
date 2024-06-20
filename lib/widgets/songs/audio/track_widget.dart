import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class TrackWidget extends StatefulWidget {
  final String trackName;

  TrackWidget({Key? key, required this.trackName}) : super(key: key);

  @override
  _TrackWidgetState createState() => _TrackWidgetState();
}

class _TrackWidgetState extends State<TrackWidget> {
  double _currentSliderValue = 75;
  bool _currentPohValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        color: Colors.white, // As pure as a new guitar string
        borderRadius: BorderRadius.circular(9.0),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.trackName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                child: Row(
                  children: [
                    const IconButton(
                      tooltip: "Play Track",
                      icon: Icon(Icons.play_arrow_outlined),
                      onPressed: null,
                    ),
                    Column(
                      children: [
                        Switch(value: _currentPohValue, onChanged: (value) {
                          setState(() {
                            _currentPohValue = value;
                          });
                        }),
                        const Text("POH", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                    Column(
                      children: [
                        Slider(
                          value: _currentSliderValue,
                          max: 100,
                          divisions: 100,
                          label: _currentSliderValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
                          },
                        ),
                        Text("Volume: ${_currentSliderValue.round()}", style: const TextStyle(fontSize: 12),),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                tooltip: "Select Audio File",
                icon: const Icon(Icons.file_copy),
                onPressed: () async {
                  // Corrected here
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    File file = File(result.files.single.path!);
                    // Use the file as needed
                  } else {
                    // User canceled the picker
                  }
                },
              ),
              const Text("Audio File...", style: TextStyle(fontSize: 12)),
            ],
          ),
          const Text("[Wave form...]", style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
