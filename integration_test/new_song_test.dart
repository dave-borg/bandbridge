import 'dart:io';

import 'package:bandbridge/models/hive_adapters/adpt_audio.dart';
import 'package:bandbridge/models/hive_adapters/adpt_bar.dart';
import 'package:bandbridge/models/hive_adapters/adpt_beat.dart';
import 'package:bandbridge/models/hive_adapters/adpt_chord.dart';
import 'package:bandbridge/models/hive_adapters/adpt_lyric.dart';
import 'package:bandbridge/models/hive_adapters/adpt_section.dart';
import 'package:bandbridge/models/hive_adapters/adpt_song.dart';
import 'package:bandbridge/models/hive_adapters/adpt_version.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:yaml/yaml.dart';
import 'package:bandbridge/main.dart';

void main() {
  setUpAll(() async {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    final String yamlContent =
        await rootBundle.loadString('assets/logging_conf.yaml');
    var doc = loadYaml(yamlContent);
    // Assuming LoggingUtil.preloadYamlContent(doc); is your application-specific logic
    LoggingUtil.preloadYamlContent(doc);

    FlutterError.onError = (details) {
      debugPrint(
          "|==========================================\nFlutter error caught");
      FlutterError.dumpErrorToConsole(details);
      // Optionally, log the error to a file or external logging service
    };

    //===========================================
    //Set up the database
    await setUpTestHive();

    Hive.registerAdapter(LyricAdapter());
    Hive.registerAdapter(ChordAdapter());
    Hive.registerAdapter(BeatAdapter());
    Hive.registerAdapter(BarAdapter());
    Hive.registerAdapter(SectionAdapter());
    Hive.registerAdapter(VersionAdapter());
    Hive.registerAdapter(AudioTrackAdapter());
    Hive.registerAdapter(
        SongAdapter()); // Initializes a temporary Hive database

    await Hive.openBox<Song>('songs');

  });

  tearDownAll(() async {
    await Hive.close();
    await tearDownTestHive(); // Cleans up any temporary directories
  });

  group('Basic adding song tests', () {
    testWidgets('Add a new song', (WidgetTester tester) async {
      // Pump the main app widget
      await tester.pumpWidget(const BandBridge());
      await tester.pumpAndSettle(const Duration(seconds: 1));
      sleep(const Duration(seconds: 1));

      try {
        final addButton = find.byKey(const Key(
            "songList_btnAddSong")); // Assuming you use an add icon to navigate
        // Tap the navigation button
        await tester.tap(addButton);
        // Wait for the navigation to complete
        await tester.pumpAndSettle();
      } catch (e) {
        debugPrint('Caught exception: $e');
      }

      // The rest of the test remains the same
      var songTitleField = find.byKey(const Key('songHeaderDialog_songTitle'));
      var artistField = find.byKey(const Key('songHeaderDialog_artist'));
      var submitButton = find.text('Submit');

      await tester.enterText(songTitleField, 'Test Song Title');
      await tester.enterText(artistField, 'Test Artist Name');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify the song was added
      // This part might need to be adjusted based on how you access the SongProvider in your app
      //expect(find.text('Test Song Title'), findsOneWidget);
      final titleFinder = find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text &&
            widget.data == 'Test Song Title' &&
            widget.key != const Key("songHeader_songTitle"),
      );
      expect(titleFinder, findsOneWidget);

      final artistFinder = find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text &&
            widget.data == 'Test Artist Name' &&
            widget.key != const Key("songHeader_songArtist"),
      );
      expect(artistFinder, findsOneWidget);
    });

    testWidgets('Add a second song', (WidgetTester tester) async {
      // Pump the main app widget
      await tester.pumpWidget(const BandBridge());
      await tester.pumpAndSettle(const Duration(seconds: 1));
      sleep(const Duration(seconds: 1));

      try {
        final addButton = find.byKey(const Key(
            "songList_btnAddSong")); // Assuming you use an add icon to navigate
        // Tap the navigation button
        await tester.tap(addButton);
        // Wait for the navigation to complete
        await tester.pumpAndSettle();
      } catch (e) {
        debugPrint('Caught exception: $e');
      }

      // The rest of the test remains the same
      var songTitleField = find.byKey(const Key('songHeaderDialog_songTitle'));
      var artistField = find.byKey(const Key('songHeaderDialog_artist'));
      var submitButton = find.text('Submit');

      await tester.enterText(songTitleField, 'Test Song Title 2');
      await tester.enterText(artistField, 'Test Artist Name 2');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify the song was added
      // This part might need to be adjusted based on how you access the SongProvider in your app
      //expect(find.text('Test Song Title'), findsOneWidget);
      final titleFinder = find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text &&
            widget.data == 'Test Song Title 2' &&
            widget.key != const Key("songHeader_songTitle"),
      );
      expect(titleFinder, findsOneWidget);

      final artistFinder = find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text &&
            widget.data == 'Test Artist Name 2' &&
            widget.key != const Key("songHeader_songArtist"),
      );
      expect(artistFinder, findsOneWidget);
    });
  });

  group('Song validation test', () {
    testWidgets('Missing song title', (WidgetTester tester) async {
      // Pump the main app widget
      await tester.pumpWidget(const BandBridge());
      await tester.pumpAndSettle(const Duration(seconds: 1));
      sleep(const Duration(seconds: 1));

      try {
        final addButton = find.byKey(const Key(
            "songList_btnAddSong")); // Assuming you use an add icon to navigate
        // Tap the navigation button
        await tester.tap(addButton);
        // Wait for the navigation to complete
        await tester.pumpAndSettle();
      } catch (e) {
        debugPrint('Caught exception: $e');
      }

      // The rest of the test remains the same
      var artistField = find.byKey(const Key('songHeaderDialog_artist'));
      var submitButton = find.text('Submit');

      await tester.enterText(artistField, 'Test Artist Name 3');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter a song title'), findsOneWidget);
    });

    testWidgets('Missing song artist', (WidgetTester tester) async {
      // Pump the main app widget
      await tester.pumpWidget(const BandBridge());
      await tester.pumpAndSettle(const Duration(seconds: 1));
      sleep(const Duration(seconds: 1));

      try {
        final addButton = find.byKey(const Key(
            "songList_btnAddSong")); // Assuming you use an add icon to navigate
        // Tap the navigation button
        await tester.tap(addButton);
        // Wait for the navigation to complete
        await tester.pumpAndSettle();
      } catch (e) {
        debugPrint('Caught exception: $e');
      }

      // The rest of the test remains the same
      var songTitleField = find.byKey(const Key('songHeaderDialog_songTitle'));
      var submitButton = find.text('Submit');

      await tester.enterText(songTitleField, 'Test Song Title 4');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter an artist'), findsOneWidget);
    });
  });
}
