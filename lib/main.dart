import 'package:flutter/material.dart';
import 'widgets/song_header.dart';
import 'widgets/song_arrangement_list.dart';
import 'widgets/song_list.dart';

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
                  //====================
                  //====================
                  // Song List

                  SongList(),

                  //====================
                  //====================
                  // Gig List
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
                    SongArrangement(),
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
