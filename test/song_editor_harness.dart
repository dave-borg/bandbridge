import 'package:bandbridge/models/hive_adapters/adpt_chord.dart';
import 'package:bandbridge/models/hive_adapters/adpt_lyric.dart';
import 'package:bandbridge/models/hive_adapters/adpt_section.dart';
import 'package:bandbridge/models/hive_adapters/adpt_song.dart';
import 'package:bandbridge/models/hive_adapters/adpt_version.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/utils/song_generator.dart';
import 'package:flutter/material.dart';
import 'package:bandbridge/widgets/songs/song-editor/song_editor_tabs.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart'; // Replace with your actual import path

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(document.path);
  Hive.registerAdapter(SectionAdapter());
  Hive.registerAdapter(ChordAdapter());
  Hive.registerAdapter(SongAdapter());
  Hive.registerAdapter(LyricAdapter());
  Hive.registerAdapter(VersionAdapter());

  await LoggingUtil.preloadYamlContent();

  runApp(const MaterialApp(home: SongEditorWrapper()));
}

class SongEditorWrapper extends StatefulWidget {
  const SongEditorWrapper({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SongEditorWrapperState createState() => _SongEditorWrapperState();
}

class _SongEditorWrapperState extends State<SongEditorWrapper> {
  late Song song;

  @override
Widget build(BuildContext context) {
  return FutureBuilder<Song>(
    future: SongGenerator.createTestSong(), // The async operation
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        // Ensure data is not null before accessing it
        if (snapshot.hasData) {
          // Use the data to build your widget
          return SongEditorTabs(song: snapshot.data!, sectionIndex: null);
        } else {
          // Handle the case where snapshot.data is null
          return const Center(child: Text('Error loading song'));
        }
      } else {
        // Show a loading spinner while waiting for the future to complete
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}
}
