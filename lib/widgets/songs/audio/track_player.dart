import 'dart:io';

import 'package:bandbridge/models/mdl_song.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class TrackPlayer {
  static TrackPlayer? _instance;
  final Song song;
  late Directory documentsDir; // Marked as late
  List<AudioPlayer> players = [];

  factory TrackPlayer(Song song) {
    _instance ??= TrackPlayer._internal(song);
    return _instance!;
  }

  TrackPlayer._internal(this.song) {
    initDirectory(); // Initialize the directory asynchronously
  }

  Future<void> initDirectory() async {
    documentsDir = await getApplicationDocumentsDirectory();
    loadPlayers();
  }

  void play() {
    print('Playing ${song.title}');
    for (int i = 0; i < song.audioTracks.length; i++) {
      playTrack(i);
    }
  }

  void playTrack(int trackIndex) {
    print('Playing ${song.title} - Track $trackIndex');

    players[trackIndex].play();
  }

  void stop() {
    for (var i = 0 ; i < song.audioTracks.length; i++) {
      stopTrack(i);
    }
  }

  void stopTrack(int trackIndex) {
    players[trackIndex].stop();
    players[trackIndex].seek(Duration.zero);
  }

  void loadPlayers() {
    for (var thisTrack in song.audioTracks) {
      var thisPlayer = AudioPlayer();
      var filePath = '${documentsDir!.path}/${song.id}/${thisTrack.fileName}';
      thisPlayer.setAudioSource(
        AudioSource.uri(
          Uri.file(filePath),
        ),
        preload: true,
      );
      thisPlayer.setVolume( thisTrack.volume / 100.0);
      players.add(thisPlayer);
    }
  }

  void dispose() {
    for (var player in players) {
      player.dispose();
    }
  }

  int getCurrentPosition() {
    if (players.isEmpty) {
      return -1;
    }
    
    return players[0].position.inMilliseconds;
  }
}
