import 'package:bandbridge/models/hive_adapters/adpt_chord.dart';
import 'package:bandbridge/models/hive_adapters/adpt_lyric.dart';
import 'package:bandbridge/models/hive_adapters/adpt_section.dart';
import 'package:bandbridge/models/hive_adapters/adpt_song.dart';
import 'package:bandbridge/models/hive_adapters/adpt_version.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/song_list.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:bandbridge/models/current_song.dart';
import 'package:flutter/material.dart';

void main() {
  var logger = Logger(level: LoggingUtil.loggingLevel('SongHeaderDialogTest'));
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');

  // Set a mock method call handler.
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getApplicationDocumentsDirectory') {
      // Return a dummy directory path.
      return '.';
    }
    return null;
  });

  CurrentSongProvider currentSongProvider = CurrentSongProvider();
  Song testSong;

  setUpAll(() async {
    // Initialize Hive and open the box.
    //final document = await getApplicationDocumentsDirectory();
    await Hive.initFlutter('./hive/');
    Hive.registerAdapter(SectionAdapter());
    Hive.registerAdapter(ChordAdapter());
    Hive.registerAdapter(SongAdapter());
    Hive.registerAdapter(LyricAdapter());
    Hive.registerAdapter(VersionAdapter());

    await Hive.initFlutter();
    if (!Hive.isBoxOpen('songs')) {
      var box = await Hive.openBox<Song>('songs');

      // Create a Song object
      testSong = Song(
        songId: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        initialKey: 'D',
        tempo: '120',
        timeSignature: '4/4',
      );

      box.put(testSong!.id, testSong!);

      currentSongProvider.setCurrentSong(testSong);
    }
  });

  tearDownAll(() async {
    try {
      Hive.deleteBoxFromDisk('songs');
      logger.d('Closing the songs Hive box');
    } catch (e) {
      logger.e('Error deleting box: $e');
    }
    // Close the box.
  });

  testWidgets('SongList Widget Test with Song object',
      (WidgetTester tester) async {
    // Create a fake CurrentSongProvider for the test

    // Add the song to the provider
    //currentSongProvider.setCurrentSong(testSong);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<CurrentSongProvider>.value(
        value: currentSongProvider,
        child: const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SongList(),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that SongList widget is displayed
    expect(find.byType(SongList), findsOneWidget);

    // Verify that the "Songs" title is displayed
    expect(find.text('Songs'), findsOneWidget);

    // Verify that the "Add Song" button is displayed
    expect(find.byKey(const Key('btn_songList_addSong')), findsOneWidget);

    // Verify that the "Sort" button is displayed
    expect(find.byIcon(Icons.sort), findsOneWidget);

    // Verify that the search box is displayed
    expect(find.byIcon(Icons.search), findsOneWidget);

    // Verify that the song title is displayed
    expect(find.byKey(const Key('songList_btn_title_1')), findsOneWidget);

    // Verify that the song artist is displayed
    expect(find.text('Test Artist'), findsOneWidget);
  });
}
