import 'package:flutter/material.dart';

class SongHeader extends StatelessWidget {
  SongHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      height: 200,
      width: MediaQuery.of(context).size.width - 250,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      'Baker Street',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Handle button press
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        // Handle button press
                      },
                    )
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle button press
                      },
                      icon: Icon(Icons.play_arrow),
                      label: Text('btnPlay'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
