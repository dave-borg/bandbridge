import 'package:flutter/material.dart';

class SongEditPanel extends StatelessWidget {
  const SongEditPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
