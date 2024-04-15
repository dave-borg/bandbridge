import 'package:flutter/material.dart';

class SongArrangement extends StatelessWidget {
  SongArrangement({super.key});

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
      child: Column(
        children: [
          // Toolbar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 30.0, // Your desired width
                child: IconButton(
                  padding: EdgeInsets.zero, // Remove padding
                  icon: const Icon(Icons.add, size: 20.0), // Set icon size
                  onPressed: () {
                    // Handle add button press
                  },
                ),
              ),
              SizedBox(
                width: 30.0, // Your desired width
                child: IconButton(
                  padding: EdgeInsets.zero, // Remove padding
                  icon: const Icon(Icons.edit, size: 20.0), // Set icon size
                  onPressed: () {
                    // Handle add button press
                  },
                ),
              ),
              SizedBox(
                width: 30.0, // Your desired width
                child: IconButton(
                  padding: EdgeInsets.zero, // Remove padding
                  icon: const Icon(Icons.content_copy,
                      size: 20.0), // Set icon size
                  onPressed: () {
                    // Handle add button press
                  },
                ),
              ),
            ],
          ),
          // ListView
          Expanded(
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
        ],
      ),
    );
  }
}
