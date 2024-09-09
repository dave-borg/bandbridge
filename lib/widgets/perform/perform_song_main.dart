import 'dart:async';

import 'package:bandbridge/models/mdl_bar.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:bandbridge/widgets/perform/PerformScrollHeaderItem.dart';
import 'package:bandbridge/widgets/perform/perform_scroll_item.dart';
import 'package:bandbridge/widgets/songs/audio/track_player.dart';
import 'package:bandbridge/widgets/songs/chord-chart/bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class PerformSongMain extends StatefulWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('PerformSongMain'));
  final Song songToPlay;
  late TrackPlayer trackPlayer;

  PerformSongMain({super.key, required this.songToPlay}) {
    trackPlayer = TrackPlayer(songToPlay);
  }

  @override
  _PerformSongScreenState createState() => _PerformSongScreenState();
}

class _PerformSongScreenState extends State<PerformSongMain> {
  final FixedExtentScrollController _lyricController =
      FixedExtentScrollController();
  final FixedExtentScrollController _barController =
      FixedExtentScrollController();
  bool _isSwitch1On = true;
  bool _isSwitch2On = true;

  Timer? periodicTimer;
  var lyrics = <Widget>[];
  var allScrollItems = <PerformScrollItem>[];

  startTimer() {
    int currentTimer = 0;

    periodicTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      currentTimer = widget.trackPlayer.getCurrentPosition();
      int barDuration = widget.songToPlay.getBarDurationMs();

      // for (var thisLyricItem in lyrics) {
      //   var lyricIndex = -1;
      //   lyricIndex = lyrics.indexOf(thisLyricItem);

      //   if (thisLyricItem.startMs > 0) {
      //     if (currentTimer >=
      //             (thisLyricItem.startMs - (barDuration / 2).round()) &&
      //         currentTimer < lyrics[lyricIndex + 1].startMs) {
      //       //scroll to this item
      //       //print('scrolling to ${thisLyricItem.displayWidget.toString()}');
      //       scrollLyrics(lyricIndex);
      //     }
      //   }
      // }

      // for (var thisBarItem in bars) {
      //   var barIndex = -1;
      //   barIndex = bars.indexOf(thisBarItem);

      //   if (thisBarItem.startMs > 0) {
      //     if (currentTimer >=
      //             (thisBarItem.startMs - (barDuration / 2).round()) &&
      //         currentTimer < bars[barIndex + 1].startMs) {
      //       //scroll to this item
      //       scrollBars(barIndex);
      //     }
      //   }
      // }
    });
  }

  stopTimer() {
    periodicTimer?.cancel();
    scrollLyrics(0);
    scrollBars(0);
  }

  scrollLyrics(int targetIndex) {
    _lyricController.animateToItem(
      targetIndex,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  scrollBars(int targetIndex) {
    _barController.animateToItem(
      targetIndex,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    allScrollItems[targetIndex].selected = true;
  }

  scrollChords(int targetIndex) {}

  @override
  void initState() {
    super.initState();
    // Populate the lyrics list with LyricScrollItem widgets
    for (var section in widget.songToPlay.sections) {
      int barsStartMs = -1;
      int barsEndMs = -1;
      var sectionPerformScrollItems = <PerformScrollItem>[];

      //add the section title
      lyrics.add(PerformScrollHeaderItem(
        headerText: section.sectionName,
      ));

      if (section.bars != null) {
        for (var i = 0; i < section.bars!.length; i += 4) {
          PerformScrollItem thisSectionItem = PerformScrollItem();

          for (var j = 0; j < 4; j++) {
            Bar thisBar;
            if (i + j < section.bars!.length) {
              thisBar = section.bars![i + j];
              //set the start time
              if (j == 0) {
                barsStartMs = thisBar.calculatedStartTimeMs;
              }

              thisSectionItem.addBars(BarWidget(bar: thisBar));
            }
            //set the last time
            barsEndMs = thisSectionItem.getLastBarStartMs();
          }

          //====================================================
          //Add the lyrics to the thisSectionItem
          for (var lyric in widget.songToPlay.getAllLyrics()) {
            if (lyric.startTimeMs >= barsStartMs &&
                lyric.startTimeMs <= barsEndMs) {
              thisSectionItem.addLyric(lyric);
            }
          }
        
          thisSectionItem.startMs = barsStartMs;
          thisSectionItem.endMs = barsEndMs;
          sectionPerformScrollItems.add(thisSectionItem);
          allScrollItems.addAll(sectionPerformScrollItems);

          widget.logger.d(allScrollItems);

//====================================================================================================
          //     var bar1 = section.bars![i];
          //     var bar2 =
          //         (i + 1 < section.bars!.length) ? section.bars![i + 1] : null;
          //     var bar3 =
          //         (i + 2 < section.bars!.length) ? section.bars![i + 2] : null;
          //     var bar4 =
          //         (i + 3 < section.bars!.length) ? section.bars![i + 3] : null;

          //     bars.add(PerformScrollItem(
          //       displayWidget:
          //       startMs: bar1.calculatedStartTimeMs,
          //     ));
          //   }
          // }

          // //build the list of lyrics for this section
          // if (section.unsynchronisedLyrics != null) {
          //   for (var lyric in section.unsynchronisedLyrics!) {
          //     lyrics.add(PerformScrollItem(
          //       displayWidget: Text(
          //         "${lyric.text} (${lyric.calculatedStartTimeMs})",
          //         style: TextStyle(
          //           fontSize: 26,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white,
          //         ),
          //       ),
          //       startMs: lyric.startTimeMs, //dangerous - need to check for null
          //     ));
          //   }
          // }

          //add the section title
          // bars.add(PerformScrollHeaderItem(
          //   headerText: section.sectionName,
          // ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.songToPlay.title} - ${widget.songToPlay.artist}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Row(
            children: [
              const Text('Lyrics'),
              Switch(
                value: _isSwitch1On,
                onChanged: _isSwitch2On
                    ? (value) {
                        setState(() {
                          _isSwitch1On = value;
                          if (!value) _isSwitch2On = true;
                        });
                      }
                    : null,
              ),
            ],
          ),
          Row(
            children: [
              const Text('Chords'),
              Switch(
                value: _isSwitch2On,
                onChanged: _isSwitch1On
                    ? (value) {
                        setState(() {
                          _isSwitch2On = value;
                          if (!value) _isSwitch1On = true;
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          backgroundBlendMode: BlendMode.darken,
          color: Colors.black,
        ),
        child: Container(
          color: Color.fromARGB(255, 49, 49, 49),
          child: ListWheelScrollView(
            controller: _barController,
            itemExtent: 200,
            diameterRatio: 3,
            squeeze: 0.75,
            useMagnifier: false,
            magnification: 1.3,
            children: allScrollItems,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                startTimer();
                widget.trackPlayer.play();
              },
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () {
                stopTimer();
                widget.trackPlayer.stop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
