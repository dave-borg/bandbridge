import 'package:flutter/material.dart';

class SongHeader extends StatelessWidget {
  SongHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width - 270,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'Baker Street',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Handle button press
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.ios_share),
                              onPressed: () {
                                // Handle button press
                              },
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Gerry Rafferty',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '4/4',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            '80 BPM',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            'F# maj',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        // padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle button press
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_arrow, size: 80),
                                Text(
                                  'Play Song',
                                  style: TextStyle(
                                    fontSize:
                                        14.0, // Set this to your desired size
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
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
