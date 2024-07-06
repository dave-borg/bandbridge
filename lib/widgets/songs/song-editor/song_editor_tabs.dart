import 'package:bandbridge/models/mdl_song.dart';
import 'package:bandbridge/widgets/songs/audio/audio_editor.dart';
import 'package:bandbridge/widgets/songs/song-editor/chord_chart_editor.dart';
import 'package:bandbridge/widgets/songs/lyrics/lyrics_editor.dart';
import 'package:flutter/material.dart';

class SongEditorTabs extends StatefulWidget {
  final Song song;
  final int? sectionIndex;

  const SongEditorTabs({super.key, required this.song, this.sectionIndex});

  @override
  // ignore: library_private_types_in_public_api
  _SongEditorTabsState createState() => _SongEditorTabsState();
}

class _SongEditorTabsState extends State<SongEditorTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 2);
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(00),
          child: TabBar(
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
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1 content
          const Center(
            child: Text('Tab 1 Contents'),
          ),
          // Tab 2 content
          Center(
            child: ChordChartEditor(song: widget.song),
          ),
          // Tab 3 content
          Center(
            child: LyricsEditor(song: widget.song),
          ),
          // Tab 4 content
          Center(
            child: AudioEditor(song: widget.song),
          ),
          // Tab 5 content
          const Center(
            child: Text('Tab 5 Content'),
          ),
        ],
      ),
    );
  }
}
