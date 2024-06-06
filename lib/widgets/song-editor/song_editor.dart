import 'package:bandbridge/widgets/song-editor/chord_chart_editor.dart';
import 'package:bandbridge/widgets/song-editor/lyrics_editor.dart';
import 'package:flutter/material.dart';

class SongEditor extends StatefulWidget {
  var song;
  int? sectionIndex;

  SongEditor({required this.song, this.sectionIndex});

  @override
  _SongEditorState createState() => _SongEditorState();
}

class _SongEditorState extends State<SongEditor>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Song'),
            Tab(text: 'Chords'),
            Tab(text: 'Lyrics'),
            Tab(text: 'Audio'),
            Tab(text: 'MIDI'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1 content
          Container(
            child: const Center(
              child: Text('Tab 1 Contents'),
            ),
          ),
          // Tab 2 content
          Container(
            child: Center(
              child: ChordChartEditor(song: widget.song),
            ),
          ),
          // Tab 3 content
          Container(
            child: Center(
              child: LyricsEditor(song: widget.song),
            ),
          ),
          // Tab 4 content
          Container(
            child: const Center(
              child: Text('Tab 4 Content'),
            ),
          ),
          // Tab 5 content
          Container(
            child: const Center(
              child: Text('Tab 5 Content'),
            ),
          ),
        ],
      ),
    );
  }
}
