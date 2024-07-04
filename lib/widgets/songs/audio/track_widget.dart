import 'dart:io';
import 'dart:typed_data';

import 'package:bandbridge/models/mdl_audio.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/models/song_provider.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/songs/audio/waveform_widget.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

// ignore: must_be_immutable
class TrackWidget extends StatefulWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('TrackWidget'));
  final AudioTrack audioTrack;
  late SongProvider currentSongProvider;
  AudioPlayer? player;
  bool isPlaying = false;
  bool isLoaded = false;

  TrackWidget({super.key, required this.audioTrack, bool? isFoh});

  @override
  // ignore: library_private_types_in_public_api
  _TrackWidgetState createState() => _TrackWidgetState();

  void play() {
    logger.d("Attempting to play track: $audioTrack.trackName");
    if (player != null) {
      player!.seek(Duration.zero);
      player!.play();
      logger.d("Playing track: $audioTrack.trackName");
      isPlaying = true;
    } else {
      // ignore: deprecated_member_use
      logger.wtf("Player is null");
    }
  }

  int getEpoch() {
    return DateTime.now().microsecondsSinceEpoch;
  }
}

class _TrackWidgetState extends State<TrackWidget> {
  bool isLoading = false;

  var progressStream = BehaviorSubject<WaveformProgress>();

  String songFilename = "Audio File...";

  @override
  void initState() {
    super.initState();
    widget.logger.d("Initializing TrackWidget");

    loadAudioAndWaveform();

    if (widget.isLoaded) {
      widget.logger.d("Track is already loaded");
    } else {
      widget.logger.d("Track is not loaded");
      widget.player = AudioPlayer();
    }
  }

  @override
  void dispose() {
    widget.player
        ?.dispose(); // Dispose of the player when the widget is disposed
    progressStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.currentSongProvider = Provider.of<SongProvider>(context);
    widget.logger.d("Building TrackWidget");
    Song song = widget.currentSongProvider.currentSong;
    Directory? documentsDir;
    String? filePath;
    double currentSliderValue = widget.audioTrack.volume;
    bool currentPohValue = widget.audioTrack.foh;

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
                widget.audioTrack.trackName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Switch(
                          value: currentPohValue,
                          onChanged: (value) {
                            setState(() {
                              currentPohValue = value;
                              widget.audioTrack.foh = currentPohValue;
                              song.save();
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
                        value: currentSliderValue,
                        max: 100,
                        divisions: 100,
                        label: currentSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            currentSliderValue = value;
                            widget.audioTrack.volume = currentSliderValue;
                            song.save();

                            if (widget.player != null) {
                              widget.player!
                                  .setVolume(currentSliderValue / 100);
                            }
                          });
                        },
                      ),
                      Text(
                        "Volume: ${currentSliderValue.round()}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                tooltip: "Select Audio File",
                icon: const Icon(Icons.file_copy),
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'flac'],
                    withData: true,
                  );

                  //=======================================================
                  // Save a new file
                  if (result != null) {
                    widget.logger.d("Saving file...");

                    PlatformFile pickedFile = result
                        .files.single; // Assuming you're picking a single file

                    result = null; //clear the result to prevent double picking

                    songFilename = pickedFile.name;
                    widget.audioTrack.fileName = songFilename;

                    Uint8List fileBytes = pickedFile
                        .bytes!; // Assuming the file has bytes (not picking a directory)

                    // Get the directory to save the file in
                    documentsDir = await getApplicationDocumentsDirectory();
                    filePath = '${documentsDir!.path}/${song.id}/$songFilename';

                    // Create a File object and write to it
                    File file = File(filePath!);

                    // Check if the directory exists, and create it if it doesn't
                    final directory = Directory(file.parent.path);
                    widget.logger.d('Directory: $directory');
                    if (!await directory.exists()) {
                      await directory.create(
                          recursive: true); // Create the directory recursively
                    }
                    await file.writeAsBytes(fileBytes.buffer.asUint8List());

                    // Optionally, inform the user
                    widget.logger.d('File saved to $filePath');

                    widget.logger.d('File picker complete');

                    song.audioTracks.add(widget.audioTrack);
                    song.save();

                    //=======================================================
                    // Load an existing file
                  } else if (widget.audioTrack.fileName.isNotEmpty) {
                    loadAudioAndWaveform();
                  } else {
                    widget.logger.d('File picker was canceled');
                  }

                  setState(() {
                    try {
                      widget.logger.d('Loading audio from file: $filePath');
                      widget.player!.setAudioSource(
                        AudioSource.uri(
                          Uri.file(filePath!),
                        ),
                        preload: true,
                      );
                    } catch (e) {
                      widget.logger.e('Error setting audio source');
                      widget.logger
                          .e('Error setting audio source: ${e.toString()}');
                    }
                    widget.isLoaded = true;
                  });

                  //=======================================================
                  //Draw the waveform
                  final waveFile = File(p.join(
                      '${documentsDir!.path}/${song.id}',
                      '${widget.audioTrack.fileName}.wave'));
                  var extractedWaveform = JustWaveform.extract(
                      audioInFile: File(filePath!), waveOutFile: waveFile);
                  extractedWaveform.listen(progressStream.add,
                      onError: progressStream.addError);
                  widget.logger.d('Waveform drawn');

                  setState(() {
                    widget.isLoaded = true;
                  });
                },
              ),
              const Text("Audio File...", style: TextStyle(fontSize: 12)),
            ],
          ),
          Column(
            children: [
              Text(widget.audioTrack.fileName),
              Row(
                children: [
                  IconButton(
                    tooltip: "Play Track",
                    icon:
                        Icon(widget.isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 40,
                    onPressed: () {
                      setState(() {
                        if (widget.player != null) {
                          if (widget.isPlaying) {
                            widget.player!.pause();
                            widget.isPlaying = false;
                          } else {
                            widget.player!.play();
                            widget.isPlaying = true;
                          }
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          //===============================================================
          // This is the waveform widget
          !widget.isLoaded
              ? const Text("No audio loaded...")
              : Container(
                  width: 500.0,
                  height: 120.0,
                  padding: const EdgeInsets.all(2.0),
                  child: StreamBuilder<WaveformProgress>(
                    stream: progressStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      final progress = snapshot.data?.progress ?? 0.0;
                      final waveform = snapshot.data?.waveform;
                      if (waveform == null) {
                        return Center(
                          child: Text(
                            '${(100 * progress).toInt()}%',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        );
                      }
                      return AudioWaveformWidget(
                        waveform: waveform,
                        start: Duration.zero,
                        duration: waveform.duration,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  void loadAudioAndWaveform() async {
    if (widget.audioTrack.fileName.isNotEmpty) {
      widget.logger.d('Loading audio from file');

      // Get the directory to save the file in
      Directory documentsDir = await getApplicationDocumentsDirectory();
      String filePath =
          '${documentsDir.path}/${widget.currentSongProvider.currentSong.id}/${widget.audioTrack.fileName}';

      setState(() {
        try {
          widget.logger.d('Loading audio from file: $filePath');
          widget.player!.setAudioSource(
            AudioSource.uri(
              Uri.file(filePath),
            ),
            preload: true,
          );
        } catch (e) {
          widget.logger.e('Error setting audio source');
          widget.logger.e('Error setting audio source: ${e.toString()}');
        }
        widget.isLoaded = true;
      });

      //=======================================================
      //Draw the waveform
      final waveFile = File(p.join(
          '${documentsDir.path}/${widget.currentSongProvider.currentSong.id}',
          '${widget.audioTrack.fileName}.wave'));
      var extractedWaveform = JustWaveform.extract(
          audioInFile: File(filePath), waveOutFile: waveFile);
      extractedWaveform.listen(progressStream.add,
          onError: progressStream.addError);
      widget.logger.d('Waveform drawn');

      setState(() {
        widget.isLoaded = true;
      });
    }
  }
}
