import 'package:bandbridge/widgets/song_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:bandbridge/models/current_song.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('SongList Widget Test', (WidgetTester tester) async {
    // Create a fake CurrentSongProvider for the test
    final currentSongProvider = CurrentSongProvider();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<CurrentSongProvider>.value(
        value: currentSongProvider,
        child: const MaterialApp(
          home: Scaffold(
            body: SongList(),
          ),
        ),
      ),
    );

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
  });
}