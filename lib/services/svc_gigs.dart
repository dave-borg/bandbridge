import 'package:bandbridge/models/mdl_gig.dart';
import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'dart:convert';

class GigsService {
  GigsService();

  Future<List<Gig>> get allGigs async {
    var logger = Logger(level: LoggingUtil.loggingLevel('GigsService'));
    logger.d("Getting all gigs");

    List<String> gigFiles = [
      'assets/gigs/gigs.json',
    ];

    List<Gig> gigs = [];

    for (var file in gigFiles) {
      String jsonString = await rootBundle.loadString(file);

      logger.d("Loaded JSON file: $file");
      logger.d("JSON data: $jsonString");

      if (jsonDecode(jsonString) != null) {
        try {
          Map<String, dynamic> gigData = jsonDecode(jsonString);

          for (var thisGig in gigData['gigs']) {
            logger.d('Gig: $thisGig');
            Gig gig = Gig.fromJson(thisGig);
            gigs.add(gig);
          }
        } catch (e) {
          logger.e('Error parsing JSON file: $file');
          logger.e(e);
        }
      } else {
        logger.e('Failed to load JSON file: $file');
      }
      logger.d('Number of gigs: ${gigs.length}');
    }
    return gigs;
  }
}
