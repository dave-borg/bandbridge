import 'package:bandbridge/models/mdl_song.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

class CurrentSongProvider extends ChangeNotifier {
  var logger = Logger();

  late Song _currentSong;
  Song get currentSong => _currentSong;

  CurrentSongProvider() {
    _currentSong = Song(); // Initialize _currentSong with a default Song
  }

  void setCurrentSong(Song song) {
    logger.d('Setting Current Song: ${song.title} - ${song.artist}');
   
    _currentSong = song;
    notifyListeners();
  }

  String get title => _currentSong.title;
  String get artist => _currentSong.artist;
  String get duration => _currentSong.duration;
  String get tempo => _currentSong.tempo;
  String get initialKey => _currentSong.initialKey;
  String get timeSignature => _currentSong.timeSignature;
  List<Section> get structure => _currentSong.structure;
  List<Version> get versions => _currentSong.versions;
}