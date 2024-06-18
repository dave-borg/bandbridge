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
      for (var i = 0; i < song.sections.length; i++) {
        var sectionPreview = PreviewSection(lyrics: []);
        sectionPreview.thisSection = song.sections[i];

        for (var j = 0; j < song.sections[i].bars!.length; j++) {
          for (var k = 0; k < song.sections[i].bars![j].beats.length; k++) {
            var lyric = song.sections[i].bars![j].beats[k].lyric;
            if (lyric != null) {
              sectionPreview.lyrics.add(lyric);
            }
          }
        }
        previewSections.add(sectionPreview);
      }
    }

    return previewSections;
  }

  void setSection({required Section section, required Lyric lyric}) {
    List<Lyric> droppedAndTrailingLyrics = [];

    //check the validity of the section - ensure this doesn't change the order of sections or lyrics

    for (var i = 0; i < song.sections.length; i++) {
      //find the lyrics
      //either in unsynchronisedLyrics or in a section
      //remove the lyric from the source

      if (song.sections[i].hashCode == section.hashCode) {
        //add lyrics to the section
      }
    }

    // for (var i = 0; i < previewSections.length; i++) {
    //   for (var j = 0; j < previewSections[i].lyrics.length; j++) {
    //     if (previewSections[i].lyrics[j].hashCode == lyric.hashCode) {
    //       droppedAndTrailingLyrics = previewSections[i].lyrics.sublist(j);
    //       previewSections[i]
    //           .lyrics
    //           .removeRange(j, previewSections[i].lyrics.length);
    //       previewSections.insert(
    //           i,
    //           PreviewSection(
    //               thisSection: section, lyrics: droppedAndTrailingLyrics));
    //       section.setLyrics(droppedAndTrailingLyrics);
    //       break;
    //     }
    //   }
    // }
  }
}

class PreviewSection {
  Section? thisSection;
  List<Lyric> lyrics = [];

  PreviewSection({this.thisSection, required lyrics});
}
