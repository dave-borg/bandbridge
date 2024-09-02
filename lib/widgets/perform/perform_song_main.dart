import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/widgets/perform/lyric_scroll_item.dart';
import 'package:bandbridge/widgets/songs/chord-chart/bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:split_view/split_view.dart';

class PerformSongMain extends StatefulWidget {
  final Song songToPlay;

  const PerformSongMain({super.key, required this.songToPlay});

  @override
  _PerformSongScreenState createState() => _PerformSongScreenState();
}

class _PerformSongScreenState extends State<PerformSongMain> {
  bool _isSwitch1On = true;
  bool _isSwitch2On = true;

  var lyrics = <LyricScrollItem>[];
  var bars = <Widget>[];

  @override
  void initState() {
    super.initState();
    // Populate the lyrics list with LyricScrollItem widgets
    for (var section in widget.songToPlay.sections) {
      //add the section title
      lyrics.add(LyricScrollItem(
        displayText: section.sectionName,
        isHeader: true,
      ));

      //build the list of lyrics for this section
      if (section.unsynchronisedLyrics != null) {
        for (var lyric in section.unsynchronisedLyrics!) {
          lyrics.add(LyricScrollItem(
            displayText: lyric.text,
            isHeader: false,
          ));
        }
      }

      //add the section title
      //bars.add(section.sectionName as Widget);

      if (section.bars != null) {
        for (var i = 0; i < section.bars!.length; i += 2) {
          var bar1 = section.bars![i];
          var bar2 =
              (i + 1 < section.bars!.length) ? section.bars![i + 1] : null;

          bars.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IntrinsicWidth(
                  child: BarWidget(bar: bar1),
                ),
                if (bar2 != null)
                  IntrinsicWidth(
                    child: BarWidget(bar: bar2),
                  ),
              ],
            ),
          );
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
        child: SplitView(
          viewMode: SplitViewMode.Vertical,
          indicator: const SplitIndicator(viewMode: SplitViewMode.Vertical),
          activeIndicator: const SplitIndicator(
            viewMode: SplitViewMode.Vertical,
            isActive: true,
          ),
          gripSize: 8.0,
          gripColor: Colors.blue,
          gripColorActive: Colors.red,
          controller: SplitViewController(
            weights: _isSwitch1On && _isSwitch2On
                ? [0.5, 0.5]
                : _isSwitch1On
                    ? [1.0, 0.0]
                    : [0.0, 1.0],
          ),
          children: [
            _isSwitch1On
                ? Container(
                    color: const Color.fromARGB(255, 35, 35, 35),
                    child: ListWheelScrollView(
                      itemExtent: 60,
                      squeeze: 0.5,
                      useMagnifier: true,
                      magnification: 1.8,
                      children: lyrics,
                    ),
                  )
                : Container(),
            _isSwitch2On
                ? Container(
                    color: Color.fromARGB(255, 49, 49, 49),
                    child: ListWheelScrollView(
                      itemExtent: 60,
                      // squeeze: 0.5,
                      useMagnifier: true,
                      magnification: 1.8,
                      children: bars,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                // Play the song
              },
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () {
                // Stop the song
              },
            ),
          ],
        ),
      ),
    );
  }
}
