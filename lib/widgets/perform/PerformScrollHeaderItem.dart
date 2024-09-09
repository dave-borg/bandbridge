import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PerformScrollHeaderItem extends StatelessWidget {
  var headerText;
  
  PerformScrollHeaderItem({super.key, required String headerText});

  @override
  Widget build(BuildContext context) {
    return Text(
          "[ ${headerText} ]",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 175, 166, 226),
          ),
        );
  }
}