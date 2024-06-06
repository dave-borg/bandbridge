// ignore_for_file: deprecated_member_use

import 'package:bandbridge/models/hive_adapters/adpt_chord.dart';
import 'package:bandbridge/models/hive_adapters/adpt_lyric.dart';
import 'package:bandbridge/models/hive_adapters/adpt_section.dart';
import 'package:bandbridge/models/hive_adapters/adpt_song.dart';
import 'package:bandbridge/models/hive_adapters/adpt_version.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/widgets/song_list.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:provider/provider.dart';
import 'package:bandbridge/models/current_song.dart';
import 'package:flutter/material.dart';

import '../test_lock.dart';

void main() {
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

  setUp(() async {
    await setUpTestHive();
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      // Check if the adapter is already registered
      Hive.registerAdapter(SongAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(SectionAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ChordAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(LyricAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(VersionAdapter());
    }
    await Hive.openBox<Song>('songs');

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

    box.put(testSong.id, testSong);

    currentSongProvider.setCurrentSong(testSong);
  });

  tearDown(() async {
    tearDownTestHive();
  });

  tearDownAll(() async {
    if (Hive.isBoxOpen('songs')) {
      Hive.box<Song>('songs').close();
      //await box.deleteFromDisk();
    }
    releaseTestLock();

  });

  setUpAll(() async {
    await acquireTestLock();
    await setUpTestHive();
  });

  testWidgets('SongList Widget Test with Song object',
      (WidgetTester tester) async {

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
