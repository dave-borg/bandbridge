import 'package:bandbridge/main.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(AppDirectoryWrapper());
}

class AppDirectoryWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: getApplicationDocumentsDirectory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const BandBridge();
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

Future<Directory> getApplicationDocumentsDirectory() async {
  return Directory('./hive/');
}
