import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class SongProvider extends ChangeNotifier {
  var logger = Logger(level: LoggingUtil.loggingLevel('CurrentSongProvider'));

  // The current song that is being edited
  late Song _currentSong;
  Song get currentSong => _currentSong;

  // A list of all songs in the temp
  List<Song> allSongs = [];

  SongProvider() {
    _currentSong = Song(); // Initialize _currentSong with a default Song
    _currentSong.id = "-2";
  }

  Future<List<Song>> get getAllSongs async {
    Box<Song> db;
    if (Hive.isBoxOpen('songs')) {
      db = Hive.box<Song>('songs');
    } else {
      db = await Hive.openBox<Song>('songs');
    }

    return db.values.toList();
  }

  //Not changing any data. This provides the currently selected song to the application context and notify listeners when it changes
  void setCurrentSong(Song song) {
    _currentSong = song;
    notifyListeners();
  }

  //Saves the song to the list of all songs and updates the current song.
  //This will update if the song already exists in the database, otherwise it will save a new song
  Future<Song> saveSong(Song updatedSong) async {
    updatedSong.save();

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
  List<Section> get structure => _currentSong.sections;

  void clearSelectedSong() {
    _currentSong = Song();
    _currentSong.id = "-2";

    notifyListeners();
  }

  Future<void> deleteSong(Song songToDelete) async {
    clearSelectedSong();
    notifyListeners();
  }
}
