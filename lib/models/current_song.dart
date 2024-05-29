import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/services/svc_songs.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class CurrentSongProvider extends ChangeNotifier {
  var logger = Logger(level: LoggingUtil.loggingLevel('CurrentSongProvider'));

  // The current song that is being edited
  late Song _currentSong;
  Song get currentSong => _currentSong;
  Future<List<Song>>? _allSongsFuture;

  // A list of all songs in the temp
  List<Song> allSongs = [];

  CurrentSongProvider() {
    _currentSong = Song(); // Initialize _currentSong with a default Song
  }

  Future<List<Song>> get getAllSongs async {
    var fetchedSongsFuture = SongsService().allSongs;
    var fetchedSongs = await fetchedSongsFuture;

    if (_allSongsFuture == null || !listEquals(fetchedSongs, allSongs)) {
      _allSongsFuture = fetchedSongsFuture;
      allSongs = fetchedSongs;
      logger.d('getAllSongs: allSongs length: ${allSongs.length}');
      logger.d(
          'Returning songs from svc\n${allSongs.map((song) => song.getDebugOutput()).join('\n')}');
    }

    return _allSongsFuture!;
  }

//Not changing any data. This provides the currently selected song to the application context and notify listeners when it changes
  void setCurrentSong(Song song) {
    logger.d(song.getDebugOutput('Setting current song'));

    _currentSong = song;
    notifyListeners();
  }

  // // Update the current song with the updated song
  // // Use this when you've made changes to the current song and want to update all references to it
  // void updateCurrentSong(Song updatedSong) {
  //   logger.d(
  //       "${_currentSong.getDebugOutput('Current Song')}\n${updatedSong.getDebugOutput('Updated Song')}");

  //   // Find the index of the old song in the list
  //   int index = allSongs
  //       .indexWhere((_currentSong) => _currentSong.id == updatedSong.id);

  //   // If the old song is found in the list, replace it with the new one
  //   if (index != -1) {
  //     logger
  //         .d(updatedSong.getDebugOutput('Updating song in list of all songs'));
  //     allSongs[index] = updatedSong;
  //   }

  //   _currentSong = updatedSong;
  //   notifyListeners();
  // }

  //Saves the song to the list of all songs and updates the current song.
  //This will update if the song already exists in the database, otherwise it will save a new song
  Future<Song> saveSong(Song updatedSong) async {
    logger.d(
        "${_currentSong.getDebugOutput('Current Song')}\n${updatedSong.getDebugOutput('Updated Song')}");

    // Find the index of the old song in the list
    int index = allSongs
        .indexWhere((_currentSong) => _currentSong.id == updatedSong.id);

    // If the old song is found in the list, replace it with the new one
    if (index != -1) {
      logger
          .d(updatedSong.getDebugOutput('Updating song in list of all songs'));
      allSongs[index] = updatedSong;
    }

    SongsService.saveAllSongs(allSongs);
    _currentSong = updatedSong;
    notifyListeners();

    return _currentSong;
  }

  // Future<void> deleteSong(Song song) async {
  //   await SongsService_temp.deleteSong(song);
  //   _refreshSongs();
  // }

  // Future<void> _refreshSongs() async {
  //   allSongs = await SongsService_temp.getAllSongs();
  //   notifyListeners();
  // }

  String get title => _currentSong.title;
  String get artist => _currentSong.artist;
  String get duration => _currentSong.duration;
  String get tempo => _currentSong.tempo;
  String get initialKey => _currentSong.initialKey;
  String get timeSignature => _currentSong.timeSignature;
  List<Section> get structure => _currentSong.structure;
  List<Version> get versions => _currentSong.versions;
}
