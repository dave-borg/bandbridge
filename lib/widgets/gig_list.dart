import 'package:flutter/material.dart';

class GigList extends StatelessWidget {
  GigList({super.key});

  final List<String> gigs = [
    'Paris Cat - 20240414',
    'Jim & Jane - 20240221',
    'Pat\'s Bar - 20240101',
    'The Tote - 20231231',
    'The Espy - 20231230',
    'The Corner - 20231229',
    'The Tote - 20231228',
    'The Tote - 20231227',
    'The Tote - 20231226',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 350,
        margin: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Colors.white, // Your desired color
          borderRadius: BorderRadius.circular(9.0),
          border: Border.all(
            color: const Color.fromRGBO(
                203, 203, 203, 1.0), // Your desired border color
            width: 1.0, // Your desired border width
          ), // Your desired corner radius
        ),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Gigs',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () {
                  // Handle button press
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Handle button press
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 35.0,
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.clear),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: gigs.map((gig) {
                return SizedBox(
                  height: 40,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(gig),
                  ),
                );
              }).toList(),
            ),
          ),
        ]));
  }
}
