import 'package:bandbridge/songs_gigs_main.dart';
import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const BandBridge());
}

class BandBridge extends StatelessWidget {
  const BandBridge({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'BandBridge',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'BandBridge'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<bool> checkIfUserIsLoggedIn() async {
    // Replace this with your actual login check
    // For example, you might check a persistent setting or make a network request
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color.fromRGBO(243, 243, 243, 1.0),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
      home: FutureBuilder<bool>(
        future: checkIfUserIsLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading spinner while waiting
          } else {
            //if (snapshot.data != null && snapshot.data!) {
            if (true) {
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color.fromRGBO(223, 223, 223, 1.0),
                    title: Text(widget.title),
                  ),
                  body:
                      const SongsGigsMain()); // Show home page if user is logged in
            } else {
              return const Scaffold(
                  body:
                      LoginScreen()); // Show login page if user is not logged in
            }
          }
        },
      ),
    );
  }
}
