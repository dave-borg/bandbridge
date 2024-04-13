import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SongHeader extends StatelessWidget {
  SongHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      height: 200,
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
    );
  }
}
