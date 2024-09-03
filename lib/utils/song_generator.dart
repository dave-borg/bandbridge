import 'package:bandbridge/models/mdl_bar.dart';
import 'package:bandbridge/models/mdl_chord.dart';
import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/models/mdl_song.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SongGenerator {
  static Future<Song> createTestSong() async {
    Song song = Song(
      title: 'Get Back',
      artist: 'The Beatles',
      tempo: "115",
      initialKey: "A",
    );

    Section intro = Section();
    intro.sectionName = 'Intro';
    intro.bars?.add(buildBar(chords: {0: Chord(rootNote: "A", beats: "4")}));
    intro.bars?.add(buildBar(chords: {0: Chord(rootNote: "A", beats: "4")}));
    intro.bars?.add(buildBar(chords: {0: Chord(rootNote: "A", beats: "4")}));
    intro.bars?.add(buildBar(chords: {
      0: Chord(rootNote: "A", beats: "2"),
      2: Chord(rootNote: "G", beats: "1"),
      3: Chord(rootNote: "D", bass: "F#", beats: "1")
    }));
    song.sections.add(intro);

    Section verse = Section();
    verse.sectionName = 'Verse';
    verse.bars?.add(buildBar(chords: {
      0: Chord(rootNote: "A", beats: "4")
    }, lyrics: {
      0: Lyric(text: "Jojo was a man who thought he was a loner", beats: "8")
    }));
    verse.bars?.add(buildBar(chords: {0: Chord(rootNote: "A", beats: "4")}));
    verse.bars?.add(buildBar(
        chords: {0: Chord(rootNote: "D", beats: "4")},
        lyrics: {0: Lyric(text: "But he knew it couldn't last", beats: "8")}));
    verse.bars?.add(buildBar(chords: {0: Chord(rootNote: "A", beats: "4")}));
    verse.bars?.add(buildBar(chords: {
      0: Chord(rootNote: "A", beats: "4")
    }, lyrics: {
      0: Lyric(text: "Jojo left his home in Tuscon, Arizona", beats: "8")
    }));
    verse.bars?.add(buildBar(chords: {0: Chord(rootNote: "A", beats: "4")}));
    verse.bars?.add(buildBar(
        chords: {0: Chord(rootNote: "D", beats: "4")},
        lyrics: {0: Lyric(text: "For some Californian grass", beats: "8")}));
    verse.bars?.add(buildBar(chords: {0: Chord(rootNote: "A", beats: "4")}));
    song.sections.add(verse);

    Section chorus = Section();
    chorus.sectionName = 'Chorus';
    chorus.bars?.add(buildBar(
        chords: {0: Chord(rootNote: "A", beats: "4")},
        lyrics: {0: Lyric(text: "Get back", beats: "4")}));
    chorus.bars?.add(buildBar(
        chords: {0: Chord(rootNote: "A", beats: "4")},
        lyrics: {0: Lyric(text: "Get back", beats: "4")}));
    chorus.bars?.add(buildBar(chords: {
      0: Chord(rootNote: "D", beats: "4")
    }, lyrics: {
      0: Lyric(text: "Get back to where you once belong", beats: "8")
    }));
    chorus.bars?.add(buildBar(chords: {
      0: Chord(rootNote: "A", beats: "2"),
      2: Chord(rootNote: "G", beats: "1"),
      3: Chord(rootNote: "D", bass: "F#", beats: "1")
    }));
    chorus.bars?.add(buildBar(
        chords: {0: Chord(rootNote: "A", beats: "4")},
        lyrics: {0: Lyric(text: "Get back", beats: "4")}));
    chorus.bars?.add(buildBar(
        chords: {0: Chord(rootNote: "A", beats: "4")},
        lyrics: {0: Lyric(text: "Get back", beats: "4")}));
    chorus.bars?.add(buildBar(chords: {
      0: Chord(rootNote: "D", beats: "4")
    }, lyrics: {
      0: Lyric(text: "Get back to where you once belong", beats: "8")
    }));
    chorus.bars?.add(buildBar(chords: {
      0: Chord(rootNote: "A", beats: "2"),
      2: Chord(rootNote: "G", beats: "1"),
      3: Chord(rootNote: "D", bass: "F#", beats: "1")
    }));
    song.sections.add(chorus);

    Section solo = Section();
    solo.sectionName = 'Keyboard Solo (Verse)';
    solo.bars?.add(buildBar(chords: {0: Chord(rootNote: "A", beats: "4")}));
    solo.bars?.add(buildBar(chords: {0: Chord(rootNote: "A", beats: "4")}));
    solo.bars?.add(buildBar(chords: {0: Chord(rootNote: "D", beats: "4")}));
    solo.bars?.add(buildBar(chords: {
      0: Chord(rootNote: "A", beats: "2"),
      2: Chord(rootNote: "G", beats: "1"),
      3: Chord(rootNote: "D", bass: "F#", beats: "1")
    }));
    solo.bars?.add(buildBar(chords: {0: Chord(rootNote: "A", beats: "4")}));
    solo.bars?.add(buildBar(chords: {0: Chord(rootNote: "A", beats: "4")}));
    solo.bars?.add(buildBar(chords: {0: Chord(rootNote: "D", beats: "4")}));
    solo.bars?.add(buildBar(chords: {
      0: Chord(rootNote: "A", beats: "2"),
      2: Chord(rootNote: "G", beats: "1"),
      3: Chord(rootNote: "D", bass: "F#", beats: "1")
    }));
    song.sections.add(solo);

    Section verse2 = Section();
    verse2.sectionName = 'Verse';
    verse2.bars?.add(buildBar(chords: {
      0: Chord(rootNote: "A", beats: "4")
    }, lyrics: {
      0: Lyric(text: "Sweet Loretta Martin thought she was a woman", beats: "8")
    }));
    verse2.bars?.add(buildBar(chords: {0: Chord(rootNote: "A", beats: "4")}));
    verse2.bars?.add(buildBar(
        chords: {0: Chord(rootNote: "D", beats: "4")},
        lyrics: {0: Lyric(text: "But she was another man", beats: "8")}));
    verse2.bars?.add(buildBar(chords: {0: Chord(rootNote: "A", beats: "4")}));
    verse2.bars?.add(buildBar(chords: {
      0: Chord(rootNote: "A", beats: "4")
    }, lyrics: {
      0: Lyric(
          text: "All the girls around her say she's got it coming", beats: "8")
    }));
    verse2.bars?.add(buildBar(chords: {0: Chord(rootNote: "A", beats: "4")}));
    verse2.bars?.add(buildBar(
        chords: {0: Chord(rootNote: "D", beats: "4")},
        lyrics: {0: Lyric(text: "But she gets it while she can", beats: "8")}));
    verse2.bars?.add(buildBar(chords: {0: Chord(rootNote: "A", beats: "4")}));
    song.sections.add(verse2);

    Section chorus2 = Section();
    chorus2.sectionName = 'Chorus';
    chorus2.bars?.add(buildBar(
        chords: {0: Chord(rootNote: "A", beats: "4")},
        lyrics: {0: Lyric(text: "Get back", beats: "4")}));
    chorus2.bars?.add(buildBar(
        chords: {0: Chord(rootNote: "A", beats: "4")},
        lyrics: {0: Lyric(text: "Get back", beats: "4")}));
    chorus2.bars?.add(buildBar(chords: {
      0: Chord(rootNote: "D", beats: "4")
    }, lyrics: {
      0: Lyric(text: "Get back to where you once belong", beats: "8")
    }));
    chorus2.bars?.add(buildBar(chords: {
      0: Chord(rootNote: "A", beats: "2"),
      2: Chord(rootNote: "G", beats: "1"),
      3: Chord(rootNote: "D", bass: "F#", beats: "1")
    }));
    chorus2.bars?.add(buildBar(
        chords: {0: Chord(rootNote: "A", beats: "4")},
        lyrics: {0: Lyric(text: "Get back", beats: "4")}));
    chorus2.bars?.add(buildBar(
        chords: {0: Chord(rootNote: "A", beats: "4")},
        lyrics: {0: Lyric(text: "Get back", beats: "4")}));
    chorus2.bars?.add(buildBar(chords: {
      0: Chord(rootNote: "D", beats: "4")
    }, lyrics: {
      0: Lyric(text: "Get back to where you once belong", beats: "8")
    }));
    chorus2.bars?.add(buildBar(chords: {
      0: Chord(rootNote: "A", beats: "2"),
      2: Chord(rootNote: "G", beats: "1"),
      3: Chord(rootNote: "D", bass: "F#", beats: "1")
    }));
    song.sections.add(chorus2);

    var box = await Hive.openBox<Song>('songs');

    box.put(song.id, song);

    Song? rValue = box.get(song.id);

    return rValue!;
  }

  static Bar buildBar({Map<int, Chord>? chords, Map<int, Lyric>? lyrics}) {
    Bar bar = Bar();
    int chordIndex = chords!.keys.first;
    for (int i = 0; i < chords.length; i++) {
      bar.setChord(chordIndex, chords[i]!);

      chordIndex += int.parse(chords[i]!.beats);
    }

    int lyricIndex = 0;
    for (int j = 0; j < lyrics!.length; j++) {
      if (lyrics.containsKey(lyricIndex)) {
        bar.setLyric(lyricIndex, lyrics[lyricIndex]!);
        lyricIndex += int.parse(lyrics[lyricIndex]!.beats);
      }
    }

    return bar;
  }
}
