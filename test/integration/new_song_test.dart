import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bandbridge/models/song_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bandbridge/widgets/songs/song_header_dialog.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:yaml/yaml.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
	// Preload YAML content
	var yamlContent = await File('assets/logging_conf.yaml').readAsString();
	var doc = loadYaml(yamlContent);
	// Assuming `preloadYamlContent` is a method you implement to make the YAML content available
	// for your application. This might involve setting a static variable, for example.
	LoggingUtil.preloadYamlContent(doc);
  });

testWidgets('Add a new song through SongHeaderDialog', (WidgetTester tester) async {
  // Initialize the song provider
  SongProvider songProvider = SongProvider();
  await tester.pumpWidget(
    ChangeNotifierProvider<SongProvider>.value(
      value: songProvider,
      child: MaterialApp(
        home: Scaffold(
          body: SongHeaderDialog(
            dialogTitle: 'Add New Song',
            onSongCreated: (song) {
              songProvider.saveSong(song);
            },
            song: Song(), // Assuming a new song is created with empty fields
          ),
        ),
      ),
    ),
  );

	// Find the form fields and submit button
	var songTitleField = find.byKey(const Key('songHeaderDialog_songTitle'));
	var artistField = find.byKey(const Key('songHeaderDialog_artist'));
	var submitButton = find.text('Submit');

	// Enter song title and artist
	await tester.enterText(songTitleField, 'New Song Title');
	await tester.enterText(artistField, 'New Artist Name');
	await tester.tap(submitButton);
	await tester.pumpAndSettle();

	// Verify the song was added
	expect(songProvider.allSongs.length, 1);
	expect(songProvider.allSongs[0].title, 'New Song Title');
	expect(songProvider.allSongs[0].artist, 'New Artist Name');
  });
}