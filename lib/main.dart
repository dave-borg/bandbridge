import 'package:flutter/material.dart';
import 'widgets/song_header.dart';

void main() {
  runApp(const BandBridge());
}

class BandBridge extends StatelessWidget {
  const BandBridge({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BandBridge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
              color: Colors.black87, fontSize: 34), // Define your style here
        ),
      ),
      home: const MyHomePage(title: 'BandBridge Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.blue,
            child: SizedBox(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
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
                  ),
                  const Text('List of gigs'),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //====================
              //====================
              // Song header panel

              SongHeader(),

              //====================
              //====================
              // Song panel with arrangement and chart

              Expanded(
                child: Row(
                  children: [
                    SizedBox(
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
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.topCenter,
                            color: Colors.brown,
                            child: Image.asset(
                              'assets/images/chart_placeholder.png',
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
