import 'package:uuid/uuid.dart';

class Song {
  String id = "-1";
  String title = "";
  String artist = "";
  String duration = "";
  String initialKey = "";
  String tempo = "";
  String timeSignature = "";
  List<Section> structure;
  List<Version> versions;

  Song({
    String? songId,
    this.title = "[Title]",
    this.artist = "[Artist]",
    this.duration = "",
    this.initialKey = "",
    this.tempo = "",
    this.timeSignature = "",
    this.structure = const [],
    this.versions = const [],
  }) : id = songId == null || songId == "-1" ? const Uuid().v4() : songId;

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      songId: json['id'],
      title: json['title'],
      artist: json['artist'],
      duration: json['duration'],
      initialKey: json['initialKey'],
      tempo: json['tempo'],
      timeSignature: json['timeSignature'],
      structure: List<Section>.from(
        json['structure']
            .map((x) => Section.fromJson(Map<String, dynamic>.from(x))),
      ),
      versions: List<Version>.from(
        json['versions']
            .map((x) => Version.fromJson(Map<String, dynamic>.from(x))),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'duration': duration,
      'initialKey': initialKey,
      'tempo': tempo,
      'timeSignature': timeSignature,
      'structure': List<dynamic>.from(structure.map((x) => x.toJson())),
      'versions': List<dynamic>.from(versions.map((x) => x.toJson())),
    };
  }

  String getDebugOutput([String debugTitle = 'Song']) {
    var rValue = "$debugTitle\n";
    rValue += "--------------\n";
    rValue += "ID: $id\n";
    rValue += "Title: $title\n";
    rValue += "Artist: $artist\n";
    rValue += "Duration: $duration\n";
    rValue += "Initial Key: $initialKey\n";
    rValue += "Tempo: $tempo\n";
    rValue += "Time Signature: $timeSignature\n";
    rValue += "Structure: ${structure.length}\n";
    rValue += "Versions: ${versions.length}\n";

    return rValue;
  }
}

class Section {
  String section;
  String timestamp;
  String duration;
  List<Chord>? chords;
  List<Lyric>? lyrics;

  Section({
    required this.section,
    required this.timestamp,
    required this.duration,
    this.chords,
    this.lyrics,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    var chordsJson = json['chords'] as List;
    var lyricsJson = json['lyrics'] as List;

    return Section(
      section: json['section'],
      timestamp: json['timestamp'],
      duration: json['duration'],
      chords: chordsJson != null
          ? List<Chord>.from(chordsJson
              .map((x) => Chord.fromJson(Map<String, dynamic>.from(x))))
          : [],
      lyrics: lyricsJson != null
          ? List<Lyric>.from(lyricsJson
              .map((x) => Lyric.fromJson(Map<String, dynamic>.from(x))))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'section': section,
      'timestamp': timestamp,
      'duration': duration,
      'chords': List<dynamic>.from(chords!.map((x) => x.toJson())),
      // ignore: unnecessary_null_comparison
      'lyrics': lyrics != null
          ? List<dynamic>.from(lyrics!.map((x) => x.toJson()))
          : null,
    };
  }
}

class Chord {
  String name;
  String beats;
  String? modifications = "";
  String? bass;

  Chord({
    required this.name,
    required this.beats,
    this.modifications,
    this.bass,
  });

  factory Chord.fromJson(Map<String, dynamic> json) {
    return Chord(
      name: json['name'],
      beats: json['beats'],
      modifications: json['modifications'],
      bass: json['bass'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'beats': beats,
      'modifications': modifications,
      'bass': bass,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class Lyric {
  String text;
  String timestamp;

  Lyric({
    required this.text,
    required this.timestamp,
  });

  factory Lyric.fromJson(Map<String, dynamic> json) {
    return Lyric(
      text: json['text'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'timestamp': timestamp,
    };
  }
}

class Version {
  String hash;
  String epoch;

  Version({
    required this.hash,
    required this.epoch,
  });

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      hash: json['hash'],
      epoch: json['epoch'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hash': hash,
      'epoch': epoch,
    };
  }
}
