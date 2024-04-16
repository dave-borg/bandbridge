import 'package:flutter/material.dart';

import 'widgets/gig_list.dart';
import 'widgets/song_arrangement_list.dart';
import 'widgets/song_edit_panel.dart';
import 'widgets/song_header.dart';
import 'widgets/song_list.dart';

class SongsGigsMain extends StatelessWidget {
  const SongsGigsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
