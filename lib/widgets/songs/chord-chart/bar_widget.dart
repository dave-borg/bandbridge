import 'package:bandbridge/models/mdl_bar.dart';
import 'package:bandbridge/widgets/songs/chord-chart/chord_container.dart';
import 'package:flutter/material.dart';

class BarWidget extends StatelessWidget {
  final Bar bar;

  BarWidget({Key? key, required this.bar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 50.0,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(5.0),
        color: bar.isHighlighted
            ? const Color.fromARGB(255, 78, 119, 188)
            : const Color.fromARGB(255, 255, 255, 255),
      ),
      child: Wrap(
        spacing: 6.0, // Adjust spacing as needed
        children: bar.beats
            .map((beat) {
              List<Widget> widgets = [];

              if (beat.chord != null) {
                widgets.add(
                  ChordContainer(
                    chord: beat.chord!,
                    width: 35,
                    // width: 15,
                    height: 50,
                  ),
                );
              } else {
                widgets.add(
                  const SizedBox(
                    width: 35,
                    //width: 15,
                    height: 30,
                    child: Text(
                      " /",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }

              return widgets;
            })
            .expand((i) => i)
            .toList(), // Flatten the list of lists into a single list
      ),
    );
  }
}
