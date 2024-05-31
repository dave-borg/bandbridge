import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('BandBridge App', () {
    final addButton = find.byValueKey('btn_songList_addSong');
    final addSongDialog = find.byValueKey('addSongDialog');

    FlutterDriver? driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      // driver = await FlutterDriver.connect(dartVmServiceUrl: 'ws://127.0.0.1:55396');
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver!.close();
      }
    });

    test('press add button and show add song dialog', () async {
      // Tap the add button.
      await driver!.tap(addButton);

      // Verify that the add song dialog is shown.
      await driver!.waitFor(addSongDialog);
    });
  });
}
