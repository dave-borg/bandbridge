import 'dart:io';
import 'dart:typed_data';

import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class TrackWidget extends StatefulWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('TrackWidget'));
  final String trackName;

  TrackWidget({Key? key, required this.trackName}) : super(key: key);

  @override
  _TrackWidgetState createState() => _TrackWidgetState();
}

class _TrackWidgetState extends State<TrackWidget> {
  double _currentSliderValue = 75;
  bool _currentPohValue = false;
  bool _isLoading = false;

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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Switch(
                            value: _currentPohValue,
                            onChanged: (value) {
                              setState(() {
                                _currentPohValue = value;
                              });
                            }),
                        const Text(
                          "FOH",
                          style: TextStyle(fontSize: 12),
                        ),
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
                        Text(
                          "Volume: ${_currentSliderValue.round()}",
                          style: const TextStyle(fontSize: 12),
                        ),
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
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'flac'],
                    withData: true,
                  );

                  widget.logger.d("result: $result");

                  if (result != null) {
                    widget.logger.d("Saving file...");

                    PlatformFile pickedFile = result
                        .files.single; // Assuming you're picking a single file
                    String fileName = pickedFile.name;

                    try {
                      Uint8List fileBytes = pickedFile
                          .bytes!; // Assuming the file has bytes (not picking a directory)

                      // Get the directory to save the file in
                      Directory documentsDir =
                          await getApplicationDocumentsDirectory();
                      String filePath = '${documentsDir.path}/audio/$fileName';

                      // Create a File object and write to it
                      File file = File(filePath);

                      // Check if the directory exists, and create it if it doesn't
                      final directory = Directory(file.parent.path);
                      widget.logger.d('Directory: $directory');
                      if (!await directory.exists()) {
                        await directory.create(
                            recursive:
                                true); // Create the directory recursively
                      }
                      await file.writeAsBytes(fileBytes);

                      // Optionally, inform the user
                      widget.logger.d('File saved to $filePath');
                    } catch (e) {
                      widget.logger.e('Error saving file');
                      widget.logger.e('Error saving file: ${e.toString()}');
                    }
                  } else {
                    // User canceled the picker
                    widget.logger.d('File picker was canceled');
                  }
                  widget.logger.d('File picker complete');
                },
              ),
              const Text("Audio File...", style: TextStyle(fontSize: 12)),
            ],
          ),
          const IconButton(
            tooltip: "Play Track",
            icon: Icon(Icons.play_arrow),
            iconSize: 40,
            onPressed: null,
          ),
          const Text("[Wave form...]", style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
