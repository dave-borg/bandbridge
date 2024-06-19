import 'package:bandbridge/models/mdl_lyric.dart';
import 'package:bandbridge/models/mdl_section.dart';
import 'package:bandbridge/models/mdl_song.dart';

class LyricsStruct {
  Song song;
  List<PreviewSection> previewSections = [];

  LyricsStruct(this.song);

  List<PreviewSection> getPreviewSections() {
    previewSections = [];

    if (song.unsynchronisedLyrics.isNotEmpty) {
      var previewSection = PreviewSection(lyrics: []);
      for (var i = 0; i < song.unsynchronisedLyrics.length; i++) {
        var lyric = song.unsynchronisedLyrics[i];
        previewSection.lyrics.add(lyric);
      }
      previewSections.add(previewSection);
    }

    if (song.sections.isNotEmpty) {
      for (var currentSection in song.sections) {
        var sectionPreview = PreviewSection(lyrics: []);
        sectionPreview.thisSection = currentSection;

        previewSections.add(sectionPreview);
      }
    }

    return previewSections;
  }

  ///Moves the Lyric and all following Lyrics (up to the next section with Lyrics) into the provided Section.
  ///This does not assign Lyrics to Bars and Beats. It only places the lyrics into the Sections' unsynchronisedLyrics list.
  ///
  ///This also checks the validity of the Section and Lyric positions, moving lyrics between sections must not
  ///change the order of either.
  void setSectionLyrics(
      {required Section destinationSection, required Lyric lyric}) {
    bool lyricFoundInSong = false;
    List<Lyric> lyricsToMove = [];
    int lyricIndex = -1;
    Section? sourceSection = null;

    for (var searchLyric in song.unsynchronisedLyrics) {
      //find the lyric
      if (searchLyric.hashCode == lyric.hashCode) {
        //skip other searches if the lyric is found
        lyricFoundInSong = true;
        lyricIndex = song.unsynchronisedLyrics.indexOf(lyric);

        lyricsToMove = song.unsynchronisedLyrics.sublist(lyricIndex);
      }
    }

    if (!lyricFoundInSong) {
      for (var section in song.sections) {
        //Don't search the section that the lyric is being moved to
        lyricIndex = section.unsynchronisedLyrics!.indexOf(lyric);

        //found it!!!
        if (lyricIndex != -1) {
          sourceSection = section;

          lyricsToMove =
              sourceSection.unsynchronisedLyrics!.sublist(lyricIndex);
          break;
        }
      }

      //Move the lyrics from a Section.
      //
      //Move the lyrics outside the loop to avoid modifying the list while iterating
      if (lyricIndex != -1) {
        destinationSection.addLyrics(lyricsToMove);
        sourceSection!.unsynchronisedLyrics!.removeRange(
            lyricIndex, sourceSection.unsynchronisedLyrics!.length);
      }
    } else {
      //Move the lyrics from the Song.
      //
      //Move the lyrics outside the loop to avoid modifying the list while iterating
      destinationSection.addLyrics(lyricsToMove);
      song.unsynchronisedLyrics
          .removeRange(lyricIndex, song.unsynchronisedLyrics.length);
    }
  }
}

class PreviewSection {
  Section? thisSection;
  List<Lyric> lyrics = [];

  PreviewSection({this.thisSection, required lyrics});

  List<Lyric> getLyrics() {
    if (lyrics.isEmpty) {
      lyrics = thisSection!.unsynchronisedLyrics!;
    }
    return lyrics;
  }
}
