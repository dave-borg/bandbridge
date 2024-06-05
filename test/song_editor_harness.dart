import 'package:bandbridge/models/hive_adapters/adpt_chord.dart';
import 'package:bandbridge/models/hive_adapters/adpt_lyric.dart';
import 'package:bandbridge/models/hive_adapters/adpt_section.dart';
import 'package:bandbridge/models/hive_adapters/adpt_song.dart';
import 'package:bandbridge/models/hive_adapters/adpt_version.dart';
import 'package:bandbridge/models/mdl_chord.dart';
import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/song_generator.dart';
import 'package:flutter/material.dart';
import 'package:bandbridge/widgets/song-editor/song_editor.dart';
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

  runApp(const MaterialApp(home: SongEditorWrapper()));
}

class SongEditorWrapper extends StatefulWidget {
  const SongEditorWrapper({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SongEditorWrapperState createState() => _SongEditorWrapperState();
}

class _SongEditorWrapperState extends State<SongEditorWrapper> {
  Song? song;

  @override
  void initState() {
    super.initState();
    SongGenerator.createTestSong().then((value) {
      setState(() {
        song = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (song == null) {
      return const CircularProgressIndicator(); // Show loading spinner while song is loading
    } else {
      print(song?.getDebugOutput("Launching editor with this song"));
      return SongEditor(song: song, sectionIndex: null);
    }
  }
}
