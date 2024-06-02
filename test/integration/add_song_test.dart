import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:bandbridge/main.dart' as app;

void main() {
  enableFlutterDriverExtension();

  app.main();

  FlutterDriver? driver;

  test('press add button and show add song dialog', () async {
    driver = await FlutterDriver.connect(
        dartVmServiceUrl: 'http://127.0.0.1:64951/cxV2S7ka1Yc=/');

    // Tap the add button.
    await driver!.tap(find.byValueKey('btn_songList_addSong'));

    // final songTitleField = find.byValueKey('songTitleField');
    // final songArtistField = find.byValueKey('songArtistField');
    // final saveButton = find.byValueKey('saveButton');

    // // Wait for the add song dialog to appear.
    // await driver!.waitFor(addSongDialog);

    // // Enter the song title and artist.
    // await driver!.tap(songTitleField);
    // await driver!.enterText('New Song');
    // await driver!.tap(songArtistField);
    // await driver!.enterText('New Artist');

    // // Tap the save button.
    // await driver!.tap(saveButton);

    // // Find the song in the song list.
    // final songInList = find.text('New Song - New Artist');

    // // Verify that the song is in the song list.
    // await driver!.waitFor(songInList);

    if (driver != null) {
      driver!.close();
    }
  });
}
