import 'package:flutter/material.dart';
import 'package:bandbridge/models/mdl_song.dart';

class LyricsEditor extends StatelessWidget {
  final Song song;
  final int? sectionIndex;

  const LyricsEditor({super.key, required this.song, this.sectionIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Add your onPressed code here.
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Add your onPressed code here.
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Add your onPressed code here.
              },
            ),
          ],
        )),
        Expanded(
          child: ListView.builder(
              itemCount: song.structure.length,
              itemBuilder: (context, i) {
                //================================================================================================
                //Only show the section if the sectionIndex is null or matches the current index
                if (sectionIndex != null && sectionIndex != i) {
                  return Container(); // Return an empty container if sectionIndex is not null and does not match the current index
                }

                //================================================================================================
                //Show the sections' header and lyrics
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        song.structure[i].section,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: song.structure[i].lyrics!.length,
                      itemBuilder: (context, j) {
                        return Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            song.structure[i].lyrics![j].text,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }
}
