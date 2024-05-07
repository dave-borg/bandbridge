import 'package:bandbridge/models/current_gig.dart';
import 'package:bandbridge/models/mdl_gig.dart';
import 'package:bandbridge/services/svc_gigs.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class GigList extends StatefulWidget {
  GigList({super.key});

  final GigsService gigsService = GigsService();

  @override
  _GigListState createState() => _GigListState();
}

class _GigListState extends State<GigList> {
  var logger = Logger(level: LoggingUtil.loggingLevel('GigList'));

  Future<List<Gig>> allGigsFuture = getAllGigs();

  TextEditingController _searchController = TextEditingController();
  List<Gig> _filteredGigs = [];
  List<Gig> _allGigs = [];

  static Future<List<Gig>> getAllGigs() {
    Logger(level: LoggingUtil.loggingLevel('GigList')).d('Getting all Gigs.');
    Future<List<Gig>> _allGigs = GigsService().allGigs;

    return _allGigs;
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Building the GigList widget');
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
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                    },
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
            child: FutureBuilder<List<Gig>>(
                future: allGigsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    logger.d("Waiting for gigs");
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    logger.d("Got gigs");

                    // If we haven't set _allGigs yet, set it to the snapshot data - should only happen on the first run
                    if (_allGigs.isEmpty) {
                      _allGigs = snapshot.data!;
                      _filteredGigs = _allGigs;
                    }

                    // If we have gigs, build the gig list
                    if (_filteredGigs.isEmpty) {
                      return const Text("No gigs found");

                      // If we have no gigs show a message
                    } else {
                      return buildGigs(_filteredGigs);
                    }
                  } else {
                    logger.d("No gigs available.");
                    return const Text("No data available");
                  }
                }),
          ),
        ]));
  }

  @override
  State<StatefulWidget> createState() {
    return _GigListState();
  }

  Widget buildGigs(List<Gig> filteredGigs) {
    logger.d("Building the gig list with ${filteredGigs.length} gigs");

    return ListView.builder(
      itemCount: filteredGigs.length,
      itemBuilder: (context, index) {
        final thisGig = filteredGigs[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Consumer<CurrentGigProvider>(
                    builder: (context, currentGigProvider, child) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          currentGigProvider.currentGig.name == thisGig.name
                              ? const Color.fromARGB(255, 237, 243, 248)
                              : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      logger.d('Gig selected: ${thisGig.name}');
                      currentGigProvider.setCurrentGig(thisGig);
                    },
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              thisGig.name,
                              style: TextStyle(
                                color: thisGig.date != null &&
                                        thisGig.date!.isBefore(DateTime.now())
                                    ? const Color.fromARGB(255, 113, 113, 113)
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              thisGig.date != null
                                  ? DateFormat('yyyy-MMM-dd')
                                      .format(thisGig.date!)
                                  : 'No date',
                              style: TextStyle(
                                color: thisGig.date != null &&
                                        thisGig.date!.isBefore(DateTime.now())
                                    ? const Color.fromARGB(255, 113, 113, 113)
                                    : Colors.black,
                              ),
                            ),
                          ],
                        )),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  _onSearchChanged() {
    logger.d("gig search text: ${_searchController.text}");
    if (_searchController.text.isEmpty || _searchController.text.length < 3) {
      logger.d("No search phrase - _allGigs: $_allGigs");
      setState(() {
        _filteredGigs = _allGigs;
      });
    } else {
      logger.d("Filtering gigs - ${_searchController.text}");
      setState(() {
        _filteredGigs = _allGigs
            .where((gig) =>
                gig.name
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) ||
                gig.notes!
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()))
            .toList();
      });
      _filteredGigs
          .forEach((gig) => logger.d('Filtered gig name: ${gig.name}'));
      logger.d("Filtered gigs: ${_filteredGigs.length}");
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }
}
