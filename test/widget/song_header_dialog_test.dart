import 'package:bandbridge/models/hive_adapters/adpt_chord.dart';
import 'package:bandbridge/models/hive_adapters/adpt_lyric.dart';
import 'package:bandbridge/models/hive_adapters/adpt_section.dart';
import 'package:bandbridge/models/hive_adapters/adpt_song.dart';
import 'package:bandbridge/models/hive_adapters/adpt_version.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/songs/song_header_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:hive_test/hive_test.dart';

import '../test_lock.dart';

void main() {
  group('Song Header Dialog Tests', () {
    var logger =
        Logger(level: LoggingUtil.loggingLevel('SongHeaderDialogTest'));
    TestWidgetsFlutterBinding.ensureInitialized();
    Song testSong = Song();

    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/path_provider');

    // Set a mock method call handler.
    // ignore: deprecated_member_use
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        // Return a dummy directory path.
        return '.';
      }
      return null;
    });

    setUpAll(() async {
      await acquireTestLock();
      await Hive.initFlutter();
      await setUpTestHive();

      testSong = Song(
        songId: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        initialKey: 'D',
        tempo: '120',
        timeSignature: '4/4',
      );
    });

    tearDownAll(() async {
      releaseTestLock();
    });

    setUp(() async {
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

      var box = Hive.isBoxOpen('songs')
          ? Hive.box('songs')
          : await Hive.openBox<Song>('songs');

      await box.add(testSong);

      var localSong = box.get(testSong.id);

      logger.d(localSong?.getDebugOutput('Song in setUp'));
    });

    tearDown(() async {
      var box = Hive.box<Song>('songs');
      testSong.delete();
      box.flush();
      if (Hive.isBoxOpen('songs')) {
        box.close();
      }
    });

    testWidgets('Form is visable and basic validation', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SongHeaderDialog(
          dialogTitle: 'Test Song Dialog',
          onSongCreated: (song) {},
          song: testSong,
        ),
      ));

      // Create the Finders.
      final titleFinder = find.text('Test Song Dialog');

      // Find the form fields.
      var songTitleField = find.byKey(const Key('songHeaderDialog_songTitle'));
      var artistField = find.byKey(const Key('songHeaderDialog_artist'));

      // Enter invalid values.
      await tester.enterText(songTitleField, '');
      await tester.enterText(artistField, '');

      // Tap the Submit button to trigger validation.
      var submitButton = find.text('Submit');
      await tester.tap(submitButton);
      await tester.pump();

      // Check if the validation message is displayed.
      expect(find.text('Please enter a song title'), findsOneWidget);

      expect(titleFinder, findsOneWidget);
    });

    testWidgets('Tempo field validation', (WidgetTester tester) async {
      var box = Hive.box<Song>('songs');

      // Build the SongHeaderDialog widget.
      Song? song = box.get(testSong.id);
      if (song == null) {
        // Handle the case where the song is null.
        // For example, you might throw an error or return.
        throw Exception('Song not found');
      }

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SongHeaderDialog(
            onSongCreated: (song) {},
            dialogTitle: 'Test Dialog',
            song: song,
          ),
        ),
      ));

      // Find the Tempo field.
      var tempoField = find.byKey(const Key('songHeaderDialog_tempo'));
      expect(tempoField, findsOneWidget);

      var submitButton = find.text('Submit');

      // Test valid input.
      await tester.enterText(tempoField, '120');
      await tester.tap(submitButton);
      await tester.pump();
      expect(find.text('Please enter a tempo in BPM'), findsNothing);

      // Test space input.
      await tester.enterText(tempoField, '120.5 ');
      await tester.tap(submitButton);
      await tester.pump();
      expect(find.text('Please enter a tempo in BPM'), findsNothing);

      // Test space input.
      await tester.enterText(tempoField, ' 120');
      await tester.tap(submitButton);
      await tester.pump();
      expect(find.text('Please enter a tempo in BPM'), findsNothing);

      // Test double input.
      await tester.enterText(tempoField, '120.5');
      await tester.tap(submitButton);
      await tester.pump();
      expect(find.text('Please enter a tempo in BPM'), findsNothing);

      // Test invalid input.
      await tester.enterText(tempoField, 'abc');
      await tester.tap(submitButton);
      await tester.pump();
      expect(find.text('Please enter a tempo in BPM'), findsOneWidget);

      // Test invalid input.
      await tester.enterText(tempoField, '12r');
      await tester.tap(submitButton);
      await tester.pump();
      expect(find.text('Please enter a tempo in BPM'), findsOneWidget);

      // Test invalid input.
      await tester.enterText(tempoField, '125.p');
      await tester.tap(submitButton);
      await tester.pump();
      expect(find.text('Please enter a tempo in BPM'), findsOneWidget);

      // Test invalid input.
      await tester.enterText(tempoField, '#%^&');
      await tester.tap(submitButton);
      await tester.pump();
      expect(find.text('Please enter a tempo in BPM'), findsOneWidget);

      // Test invalid input.
      await tester.enterText(tempoField, '14**');
      await tester.tap(submitButton);
      await tester.pump();
      expect(find.text('Please enter a tempo in BPM'), findsOneWidget);
    });

    testWidgets('Form fields are initialized with Song attributes',
        (tester) async {
      // Pump the SongHeaderDialog widget with the created Song object.
      await tester.pumpWidget(MaterialApp(
        home: SongHeaderDialog(
          dialogTitle: 'Test Song Dialog',
          onSongCreated: (song) {},
          song: testSong,
        ),
      ));

      // Find the form fields.
      var songTitleField = find.byKey(const Key('songHeaderDialog_songTitle'));
      var artistField = find.byKey(const Key('songHeaderDialog_artist'));
      var songKeyField = find.byKey(const Key('songHeaderDialog_songKey'));
      var tempoField = find.byKey(const Key('songHeaderDialog_tempo'));
      var timeSignatureField =
          find.byKey(const Key('songHeaderDialog_timeSignature'));

      // Check if the initial values of the form fields match the attributes of the Song object.
      expect(tester.widget<FormField>(songTitleField).initialValue,
          equals(testSong.title));
      expect(tester.widget<FormField>(artistField).initialValue,
          equals(testSong.artist));
      expect(tester.widget<DropdownButtonFormField>(songKeyField).initialValue,
          equals(testSong.initialKey));
      expect(tester.widget<FormField>(tempoField).initialValue,
          equals(testSong.tempo));
      expect(
          tester
              .widget<DropdownButtonFormField>(timeSignatureField)
              .initialValue,
          equals(testSong.timeSignature));
    });

    testWidgets('Form validation with different combinations', (tester) async {
      var box = Hive.box<Song>('songs');

      Song? song = box.get(testSong.id);
      if (song == null) {
        // Handle the case where the song is null.
        // For example, you might throw an error or return.
        throw Exception('Song not found');
      }

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SongHeaderDialog(
            onSongCreated: (song) {},
            dialogTitle: 'Test Dialog',
            song: song,
          ),
        ),
      ));

      // Find the form fields.
      var songTitleField = find.byKey(const Key('songHeaderDialog_songTitle'));
      var artistField = find.byKey(const Key('songHeaderDialog_artist'));

      // Enter invalid values.
      await tester.enterText(songTitleField, '');
      await tester.enterText(artistField, '');
      // Tap the Submit button to trigger validation.
      var submitButton = find.text('Submit');
      await tester.tap(submitButton);
      await tester.pump();
      // Check if the validation message is displayed.
      expect(find.text('Please enter a song title'), findsOneWidget);

      // Enter valid song title but invalid artist.
      await tester.enterText(songTitleField, 'Test Song');
      await tester.enterText(artistField, '');
      await tester.tap(submitButton);
      await tester.pump();
      // Check if the validation message is displayed.
      expect(find.text('Please enter an artist'), findsOneWidget);

      // Enter valid values.
      await tester.enterText(songTitleField, 'Test Song');
      await tester.enterText(artistField, 'Test Artist');
      await tester.tap(submitButton);
      await tester.pump();
      // Check if the validation message is not displayed.
      expect(find.text('Please enter a song title'), findsNothing);
      expect(find.text('Please enter an artist'), findsNothing);
    });

    testWidgets('Test saving changes to database', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SongHeaderDialog(
          dialogTitle: 'Test Song Dialog',
          onSongCreated: (song) {},
          song: testSong,
        ),
      ));

      // Find the form fields.
      var songTitleField = find.byKey(const Key('songHeaderDialog_songTitle'));
      var artistField = find.byKey(const Key('songHeaderDialog_artist'));
      var submitButton = find.text('Submit');
      tester.ensureVisible(submitButton);

      // Enter valid song title but invalid artist.
      await tester.enterText(songTitleField, 'Test Song2');
      await tester.enterText(artistField, 'Test Artist2');
      await tester.tap(submitButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));
      // Check if the validation message is displayed.

      logger.d(testSong.getDebugOutput('Song in test saving changes'));

      expect(testSong.title, 'Test Song2');
    });
  });
}
