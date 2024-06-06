import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/models/mdl_version.dart';
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
    _currentSong.id = "-2";
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

  //Saves the song to the list of all songs and updates the current song.
  //This will update if the song already exists in the database, otherwise it will save a new song
  Future<Song> saveSong(Song updatedSong) async {
    logger.d(
        "${_currentSong.getDebugOutput('Current Song')}\n${updatedSong.getDebugOutput('Updated Song')}");

    // Find the index of the old song in the list
    int index = allSongs
        .indexWhere((localCurrentSong) => localCurrentSong.id == updatedSong.id);

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

  String get title => _currentSong.title;
  String get artist => _currentSong.artist;
  String get duration => _currentSong.duration;
  String get tempo => _currentSong.tempo;
  String get initialKey => _currentSong.initialKey;
  String get timeSignature => _currentSong.timeSignature;
  List<Section> get structure => _currentSong.structure;
  List<Version> get versions => _currentSong.versions;

  void clearSelectedSong() {
    _currentSong = Song();
    _currentSong.id = "-2";

    notifyListeners();
  }
}
