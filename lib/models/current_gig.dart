import 'package:bandbridge/models/mdl_gig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

class CurrentGigProvider extends ChangeNotifier {
  var logger = Logger();

  late Gig _currentGig;
  Gig get currentGig => _currentGig;

  CurrentGigProvider() {
    _currentGig =
        Gig(name: ''); // Initialize _currentSong with an empty default Gig
  }

  void setCurrentGig(Gig currentGig) {
    logger.d(
        'Setting Current Gig: ${currentGig.name} - ${currentGig.date.toString()}');

    _currentGig = currentGig;
    notifyListeners();
  }

  String get title => _currentGig.name;
  String get vanue => _currentGig.venue!;
  DateTime get date => _currentGig.date!;
  String get notes => _currentGig.notes!;
}
