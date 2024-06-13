class ChordModifiers {
  static const int major = 0;
  static const int minor = 1;
  static const int diminished = 2;
  static const int halfDiminished = 3;
  static const int augmented = 4;
  static const int suspended = 5;
  static const int majorSeventh = 6;
  static const int minorSeventh = 7;
  static const int ninth = 8;
  static const int eleventh = 9;
  static const int thirteenth = 10;

  //  This method, render, takes an integer modifier as input and returns a string representation of the
  //  corresponding chord symbol.
  //
  //  Inside the method, there is a chordSymbols map that maps each modifier value to its corresponding
  //  chord symbol. The map is defined using curly braces {} and follows the format key: value. The keys
  //  are the modifier values, and the values are the chord symbols associated with each modifier.
  //
  //  The method then uses the modifier input as the key to look up the chord symbol in the chordSymbols
  //  map. If a matching chord symbol is found, it is returned. If the modifier value does not exist in
  //  the map, the ?? operator is used to provide a default value of an empty string "".
  //
  //  For example, if you call ChordModifiers.render(1), it will return the string "m" because the
  //  chordSymbols map has a key-value pair of 1: "m". Similarly, calling ChordModifiers.render(6) will
  //  return "Maj7" because the map has a key-value pair of 6: "Maj7". If you call ChordModifiers.render(11),
  //  it will return an empty string "" because there is no corresponding chord symbol for the key 11 in
  //  the map.
  static String render(int modifier) {
    var chordSymbols = {
      0: "",
      1: "m",
      2: "\u00B0",
      3: "\u00F8",
      4: "\u002B",
      5: "sus4",
      6: "maj7",
      7: "7",
      8: "9",
      9: "11",
      10: "13",
    };

    return chordSymbols[modifier] ?? "";
  }
}
