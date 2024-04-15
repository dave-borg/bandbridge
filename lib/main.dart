import 'package:bandbridge/widgets/song_edit_panel.dart';
import 'package:flutter/material.dart';
import 'widgets/song_header.dart';
import 'widgets/song_arrangement_list.dart';
import 'widgets/song_list.dart';
import 'widgets/gig_list.dart';

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
        scaffoldBackgroundColor: const Color.fromRGBO(243, 243, 243, 1.0),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
      home: const MyHomePage(title: 'BandBridge'),
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
        backgroundColor: const Color.fromRGBO(223, 223, 223, 1.0),
        title: Text(widget.title),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
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
                GigList(),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 0, top: 6, right: 0, bottom: 6),
            decoration: BoxDecoration(
              color: Colors.white, // Your desired color
              borderRadius: BorderRadius.circular(9.0),
              border: Border.all(
                color: const Color.fromRGBO(
                    203, 203, 203, 1.0), // Your desired border color
                width: 1.0, // Your desired border width
              ), // Your desired corner radius
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //====================
                //====================
                // Song header panel

                const SongHeader(),

                //====================
                //====================
                // Song panel with arrangement and chart

                Expanded(
                  child: Row(
                    children: [
                      SongArrangement(),
                      const SongEditPanel(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
