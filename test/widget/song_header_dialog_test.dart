import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/songs/song_header_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

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

  setUpAll(() async {
    // Initialize Hive and open the box.
    await Hive.initFlutter();
    if (!Hive.isBoxOpen('songs')) {
      await Hive.openBox<Song>('songs');
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

  testWidgets('Form is visable and basic validation', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SongHeaderDialog(
        dialogTitle: 'Test Song Dialog',
        onSongCreated: (song) {},
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

  testWidgets('Form validation with different combinations', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SongHeaderDialog(
        dialogTitle: 'Test Song Dialog',
        onSongCreated: (song) {},
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

  testWidgets('Tempo field validation', (WidgetTester tester) async {
    // Build the SongHeaderDialog widget.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SongHeaderDialog(
          onSongCreated: (song) {},
          dialogTitle: 'Test Dialog',
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
    // Create a Song object with known attributes.
    Song testSong = Song(
      songId: '1',
      title: 'Test Song',
      artist: 'Test Artist',
      initialKey: 'D',
      tempo: '120',
      timeSignature: '4/4',
    );

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
        tester.widget<DropdownButtonFormField>(timeSignatureField).initialValue,
        equals(testSong.timeSignature));
  });
}
