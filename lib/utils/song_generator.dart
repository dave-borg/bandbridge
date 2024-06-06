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
    intro.section = 'Intro';
    intro.chords?.add(Chord(name: "A", beats: "14"));
    intro.chords?.add(Chord(name: "G", beats: "1"));
    intro.chords?.add(Chord(name: "D", bass: "F#", beats: "1"));
    song.structure.add(intro);

    Section verse = Section();
    verse.section = 'Verse';
    verse.chords?.add(Chord(name: "A", beats: "8"));
    verse.lyrics?.add(
        Lyric(text: "Jojo was a man who thought he was a loner", beats: "8"));
    verse.chords?.add(Chord(name: "D", beats: "4"));
    verse.lyrics?.add(Lyric(text: "But he knew it couldn't last", beats: "8"));
    verse.chords?.add(Chord(name: "A", beats: "4"));
    verse.chords?.add(Chord(name: "A", beats: "8"));
    verse.lyrics
        ?.add(Lyric(text: "Jojo left his home in Tuscon, Arizona", beats: "8"));
    verse.chords?.add(Chord(name: "D", beats: "4"));
    verse.lyrics?.add(Lyric(text: "For some Californian grass", beats: "8"));
    verse.chords?.add(Chord(name: "A", beats: "2"));
    verse.chords?.add(Chord(name: "G", beats: "1"));
    verse.chords?.add(Chord(name: "D", bass: "F#", beats: "1"));
    song.structure.add(verse);

    Section chorus = Section();
    chorus.section = 'Chorus';
    chorus.chords?.add(Chord(name: "A", beats: "8"));
    chorus.lyrics?.add(Lyric(text: "Get back", beats: "4"));
    chorus.lyrics?.add(Lyric(text: "Get back", beats: "4"));
    chorus.chords?.add(Chord(name: "D", beats: "4"));
    chorus.lyrics
        ?.add(Lyric(text: "Get back to where you once belong", beats: "8"));
    chorus.chords?.add(Chord(name: "A", beats: "4"));
    chorus.chords?.add(Chord(name: "A", beats: "8"));
    chorus.lyrics?.add(Lyric(text: "Get back", beats: "4"));
    chorus.lyrics?.add(Lyric(text: "Get back", beats: "4"));
    chorus.chords?.add(Chord(name: "D", beats: "4"));
    chorus.lyrics
        ?.add(Lyric(text: "Get back to where you once belong", beats: "8"));
    chorus.chords?.add(Chord(name: "A", beats: "4"));
    song.structure.add(chorus);

    Section solo = Section();
    solo.section = 'Keyboard Solo (Verse)';
    solo.chords?.add(Chord(name: "A", beats: "8"));
    solo.chords?.add(Chord(name: "D", beats: "4"));
    solo.chords?.add(Chord(name: "A", beats: "4"));
    solo.chords?.add(Chord(name: "A", beats: "8"));
    solo.chords?.add(Chord(name: "D", beats: "4"));
    solo.chords?.add(Chord(name: "A", beats: "2"));
    solo.chords?.add(Chord(name: "G", beats: "1"));
    solo.chords?.add(Chord(name: "D", bass: "F#", beats: "1"));
    song.structure.add(solo);

    Section verse2 = Section();
    verse2.section = 'Verse';
    verse2.chords?.add(Chord(name: "A", beats: "8"));
    verse2.lyrics?.add(Lyric(
        text: "Sweet Loretta Martin thought she was a woman", beats: "8"));
    verse2.chords?.add(Chord(name: "D", beats: "4"));
    verse2.lyrics?.add(Lyric(text: "But she was another man", beats: "8"));
    verse2.chords?.add(Chord(name: "A", beats: "4"));
    verse2.chords?.add(Chord(name: "A", beats: "8"));
    verse2.lyrics?.add(Lyric(
        text: "All the girls around her say she's got it coming", beats: "8"));
    verse2.chords?.add(Chord(name: "D", beats: "4"));
    verse2.lyrics
        ?.add(Lyric(text: "But she gets it while she can", beats: "8"));
    verse2.chords?.add(Chord(name: "A", beats: "2"));
    verse2.chords?.add(Chord(name: "G", beats: "1"));
    verse2.chords?.add(Chord(name: "D", bass: "F#", beats: "1"));
    song.structure.add(verse2);

    Section chorus2 = Section();
    chorus2.section = 'Chorus';
    chorus2.chords?.add(Chord(name: "A", beats: "8"));
    chorus2.lyrics?.add(Lyric(text: "Get back", beats: "4"));
    chorus2.lyrics?.add(Lyric(text: "Get back", beats: "4"));
    chorus2.chords?.add(Chord(name: "D", beats: "4"));
    chorus2.lyrics
        ?.add(Lyric(text: "Get back to where you once belong", beats: "8"));
    chorus2.chords?.add(Chord(name: "A", beats: "4"));
    chorus2.chords?.add(Chord(name: "A", beats: "8"));
    chorus2.lyrics?.add(Lyric(text: "Get back", beats: "4"));
    chorus2.lyrics?.add(Lyric(text: "Get back", beats: "4"));
    chorus2.chords?.add(Chord(name: "D", beats: "4"));
    chorus2.lyrics
        ?.add(Lyric(text: "Get back to where you once belong", beats: "8"));
    chorus2.chords?.add(Chord(name: "A", beats: "4"));
    song.structure.add(chorus2);

    var box = await Hive.openBox<Song>('songs');

    box.put(song.id, song);

    Song? rValue = box.get(song.id);

    return rValue!;
  }
}
