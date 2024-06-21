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
    Section? sourceSection;

    //================================================================================================
    //Moving the section start
    if (destinationSection.unsynchronisedLyrics!.isNotEmpty) {
      int droppedLyricIndex = indexOfFullLyrics(lyric);
      int sectionFirstLyricIndex =
          indexOfFullLyrics(destinationSection.unsynchronisedLyrics![0]);
      int sectionIndex = song.sections.indexOf(destinationSection);

      //Moving the section up
      if (droppedLyricIndex < sectionFirstLyricIndex) {
        if (lyricIsInPreviousSection(destinationSection, lyric)) {
          //move the lyric to the songs unsynchronisedLyrics
          if (sectionIndex == 0) {
            List<Lyric> lyricsToMove = song.unsynchronisedLyrics
                .sublist(song.unsynchronisedLyrics.indexOf(lyric));
            song.unsynchronisedLyrics.removeRange(
                song.unsynchronisedLyrics.indexOf(lyric),
                song.unsynchronisedLyrics.length);
            destinationSection.unsynchronisedLyrics!.insertAll(0, lyricsToMove);
          } else {
            //move the lyric to the previous section
            Section previousSection = song.sections[sectionIndex - 1];
            List<Lyric> lyricsToMove = previousSection.unsynchronisedLyrics!
                .sublist(previousSection.unsynchronisedLyrics!.indexOf(lyric));
            previousSection.unsynchronisedLyrics!.removeRange(
                previousSection.unsynchronisedLyrics!.indexOf(lyric),
                previousSection.unsynchronisedLyrics!.length);
            destinationSection.unsynchronisedLyrics!.insertAll(0, lyricsToMove);
          }
        }

        //moving the section down
      } else if (lyricIsInCurrentSection(destinationSection, lyric)) {
        //move the lyric to the songs unsynchronisedLyrics
        if (sectionIndex == 0) {
          List<Lyric> lyricsToMove = destinationSection.unsynchronisedLyrics!
              .sublist(
                  0, destinationSection.unsynchronisedLyrics!.indexOf(lyric));
          destinationSection.unsynchronisedLyrics!.removeRange(
              0, destinationSection.unsynchronisedLyrics!.indexOf(lyric));
          song.unsynchronisedLyrics.addAll(lyricsToMove);
        } else {
          //move the lyric to the previous section
          Section previousSection = song.sections[sectionIndex - 1];
          List<Lyric> lyricsToMove = destinationSection.unsynchronisedLyrics!
              .sublist(
                  0, destinationSection.unsynchronisedLyrics!.indexOf(lyric));
          destinationSection.unsynchronisedLyrics!.removeRange(
              0, destinationSection.unsynchronisedLyrics!.indexOf(lyric));
          previousSection.unsynchronisedLyrics!.addAll(lyricsToMove);}
      }
    }

    //================================================================================================
    //Dropping the section into the song.unsynchronisedLyrics Lyrics
    for (var searchLyric in song.unsynchronisedLyrics) {
      //find the lyric
      if (searchLyric.hashCode == lyric.hashCode) {
        //skip other searches if the lyric is found
        lyricFoundInSong = true;
        lyricIndex = song.unsynchronisedLyrics.indexOf(lyric);

        lyricsToMove = song.unsynchronisedLyrics.sublist(lyricIndex);
      }
    }

    //================================================================================================
    //Dropping the section into the section.unsynchronisedLyrics Lyrics
    if (!lyricFoundInSong) {
      for (var section in song.sections) {
        //Don't search the section that the lyric is being moved to
        //prependLyrics
        //appendLyrics
        //sublistLyrics

        if (section.hashCode == destinationSection.hashCode) {
          continue;
        }

        lyricIndex = section.unsynchronisedLyrics!.indexOf(lyric);

        //found it!!!
        if (lyricIndex != -1) {
          sourceSection = section;

          lyricsToMove =
              sourceSection.unsynchronisedLyrics!.sublist(lyricIndex);
          break;
        }
      }

      //================================================================================================
      //Actually move the lyrics
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

  ///Finds the index of the lyric in the full list of lyrics - regardless of which
  ///section it is in.
  ///
  ///Will return -1 if the lyric is not found.
  int indexOfFullLyrics(Lyric lyric) {
    //build a list of all lyrics - easier to search through
    List<Lyric> allLyrics = [];
    allLyrics.addAll(song.unsynchronisedLyrics);

    for (var section in song.sections) {
      allLyrics.addAll(section.unsynchronisedLyrics!);
    }

    return allLyrics.indexOf(lyric);
  }

  ///Checks if the Lyric is in the previous section. This tests if the section header is
  ///moving up that it is not going beyond the previous section. That would be an invalid move as
  ///it reorders the song structure
  bool lyricIsInPreviousSection(Section destinationSection, Lyric lyric) {
    bool rValue = false;
    int droppedSectionIndex = song.sections.indexOf(destinationSection);

    //previous 'section' is the song.unsynchronisedLyrics
    if (droppedSectionIndex == 0) {
      rValue = song.unsynchronisedLyrics.contains(lyric);
    } else {
      Section previousSection = song.sections[droppedSectionIndex - 1];
      rValue = previousSection.unsynchronisedLyrics!.contains(lyric);
    }
    return rValue;
  }

  ///Checks if the Lyric is in the current section. This tests if the section header is
  ///moving down that it is not going beyond the previous section. That would be an invalid move as
  ///it reorders the song structure
  bool lyricIsInCurrentSection(Section destinationSection, Lyric lyric) {
    return destinationSection.unsynchronisedLyrics!.contains(lyric);
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
