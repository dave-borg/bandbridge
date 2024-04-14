import 'package:flutter/material.dart';

class SongArrangement extends StatelessWidget {
  SongArrangement();

  final List<String> arrangement = [
    'Intro',
    'Verse',
    'Chorus',
    'Verse',
    'Chorus',
    'Bridge',
    'Chorus',
    'Outro',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Column(
            children: arrangement.map((section) {
              return SizedBox(
                height: 40,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(section),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
