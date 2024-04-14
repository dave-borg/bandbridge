import 'package:flutter/material.dart';

class SongList extends StatelessWidget {
  SongList();

  final List<String> songs = [
    'All Out Of Love - Air Supply',
    'Baker Street - Gerry Rafferty',
    'Careless Whisper - George Michael',
    'Choir Girl - Cold Chisel',
    'Don\'t Stop Believin\' - Journey',
    'Every Breath You Take - The Police',
    'Eye of the Tiger - Survivor',
    'Faith - George Michael',
    'Footloose - Kenny Loggins',
    'Seven Nation Army - The White Stripes',
    'Valerie - Amy Winehouse',
    'Walking on Sunshine - Katrina and the Waves',
    'You Give Love a Bad Name - Bon Jovi',
    'Weather With You - Crowded House',
    'Under the Milky Way - The Church',
    'Throw Your Arms Around Me - Hunters & Collectors',
    'Something - The Beatles',
    'One and Only - Adele',
    'You\'re no Good - Linda Ronstadt',
    'Wonderwall - Oasis',
    'Heart of Glass - Blondie',
    'I Want to Break Free - Queen',
    'I Will Survive - Gloria Gaynor',
    'I\'m Gonna Be (500 Miles) - The Proclaimers',
    'I\'m Like a Bird - Nelly Furtado',
    'I\'m Yours - Jason Mraz',
    'I\'m a Believer - The Monkees',
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: <Widget>[
        Text(
          'Songs',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SearchBar(
          hintText: 'Search for songs',
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              Column(
                children: songs.map((song) {
                  return SizedBox(
                    height: 40,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(song),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        )
      ]),
    );
  }
}
