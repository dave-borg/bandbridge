class Song {
  String title = "";
  String artist = "";
  String duration = "";
  //String key = "";
  String tempo = "";
  String timeSignature = "";
  List<Section> structure;
  List<Version> versions;

  Song({
    this.title = "",
    this.artist = "",
    this.duration = "",
    //this.key = "",
    this.tempo = "",
    required this.timeSignature,
    required this.structure,
    required this.versions,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'],
      artist: json['artist'],
      duration: json['duration'],
      //key: json['key'],
      tempo: json['tempo'],
      timeSignature: json['timeSignature'],
      structure:
          List<Section>.from(json['structure'].map((x) => Section.fromJson(x))),
      versions:
          List<Version>.from(json['versions'].map((x) => Version.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'duration': duration,
      //'key': key,
      'tempo': tempo,
      'timeSignature': timeSignature,
      'structure': List<dynamic>.from(structure.map((x) => x.toJson())),
      'versions': List<dynamic>.from(versions.map((x) => x.toJson())),
    };
  }
}

class Section {
  String section;
  String timestamp;
  String duration;
  List<Chord> chords;
  List<Lyric> lyrics;

  Section({
    required this.section,
    required this.timestamp,
    required this.duration,
    required this.chords,
    required this.lyrics,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      section: json['section'],
      timestamp: json['timestamp'],
      duration: json['duration'],
      chords: List<Chord>.from(json['chords'].map((x) => Chord.fromJson(x))),
      lyrics: json['lyrics'] != null
          ? List<Lyric>.from(json['lyrics'].map((x) => Lyric.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'section': section,
      'timestamp': timestamp,
      'duration': duration,
      'chords': List<dynamic>.from(chords.map((x) => x.toJson())),
      'lyrics': lyrics != null
          ? List<dynamic>.from(lyrics.map((x) => x.toJson()))
          : null,
    };
  }
}

class Chord {
  String name;
  String beats;
  String modifications = "";
  String bass;

  Chord({
    required this.name,
    required this.beats,
    required this.modifications,
    required this.bass,
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
