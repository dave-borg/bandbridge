import 'dart:io';

import 'package:bandbridge/main.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:yaml/yaml.dart';

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

  group('Adding sections', () {
    testWidgets('Add a new song section', (WidgetTester tester) async {
      //add a section
      await tester.pumpWidget(const BandBridge());
      await tester.pumpAndSettle(const Duration(seconds: 1));
      sleep(const Duration(seconds: 1));

      //================================================================
      //create test song
      final addButton = find.byKey(const Key(
          "songList_btnAddSong")); // Assuming you use an add icon to navigate
      // Tap the navigation button
      await tester.tap(addButton);
      // Wait for the navigation to complete
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('songHeaderDialog_songTitle')), 'Test Song');
      await tester.enterText(
          find.byKey(const Key('songHeaderDialog_artist')), 'Test Artist');
      await tester.enterText(
          find.byKey(const Key('songHeaderDialog_tempo')), '135.4');
      await tester.tap(find.byKey(const Key('songHeaderDialog_songKey')));
      await tester.pumpAndSettle();
      var keyItemToSelect = find.text('A').first;
      await tester.tap(keyItemToSelect);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('songHeaderDialog_timeSignature')));
      await tester.pumpAndSettle();
      var sigItemToSelect = find.text('3/4').first;
      await tester.tap(sigItemToSelect);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      //================================================================
      //add a section
      final addSectionButton = find.byKey(const Key("songList_btnAddSection"));
      await tester.tap(addSectionButton);
      await tester.pumpAndSettle();

      final submitButton = find.byKey(const Key("songSectionDialog_submit"));
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      sleep(const Duration(seconds: 1));

      expect(find.text('Please enter a section title\n(eg. Verse, Chorus)'),
          findsOneWidget);

      //songSectionDialog_sectionTitle
      await tester.enterText(
          find.byKey(const Key('songSectionDialog_sectionTitle')), 'Section 1');

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      sleep(const Duration(seconds: 2));

      final sectionFinder = find.byWidgetPredicate(
        (Widget widget) =>
            widget is ListTile &&
            widget.key == const Key("song_section_0") &&
            widget.title is Text &&
            (widget.title as Text).data == 'Section 1',
      );
      sleep(const Duration(seconds: 2));
      expect(sectionFinder, findsOneWidget);
    });
  });
}
