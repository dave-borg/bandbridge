import 'package:flutter/material.dart';

class SongEditPanel extends StatelessWidget {
  const SongEditPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 40,
              width: 140,
              child: const Text('Intro',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Myriad Pro',
                  )),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(5.0),
              height: 80,
              width: 140,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color:
                        Colors.black, // Change this color to the one you prefer
                    width: 3.0, // Change this value to the one you prefer
                  ),
                ),
              ),
              child: RichText(
                text: const TextSpan(
                  text: 'C\u266F',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Myriad Pro',
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'm',
                      style: TextStyle(
                        fontSize: 20,
                        // 75% of the original size
                        //baseline: TextBaseline.alphabetic,
                        textBaseline: TextBaseline.alphabetic,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(5.0),
              height: 80,
              width: 140,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color:
                        Colors.black, // Change this color to the one you prefer
                    width: 3.0, // Change this value to the one you prefer
                  ),
                ),
              ),
              child: RichText(
                text: const TextSpan(
                  text: 'A',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Myriad Pro',
                    color: Colors.black,
                  ),
                  
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(5.0),
              height: 80,
              width: 140,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color:
                        Colors.black, // Change this color to the one you prefer
                    width: 3.0, // Change this value to the one you prefer
                  ),
                ),
              ),
              child: RichText(
                text: const TextSpan(
                  text: 'G\u266F',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Myriad Pro',
                    color: Colors.black,
                  ),
                  
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(5.0),
              height: 80,
              width: 140,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color:
                        Colors.black, // Change this color to the one you prefer
                    width: 3.0, // Change this value to the one you prefer
                  ),
                  right: BorderSide(
                    color:
                        Colors.black, // Change this color to the one you prefer
                    width: 3.0, // Change this value to the one you prefer
                  ),
                ),
              ),
              child: RichText(
                text: const TextSpan(
                  text: 'G\u266F',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Myriad Pro',
                    color: Colors.black,
                  ),
                  
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
