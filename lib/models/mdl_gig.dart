import 'package:bandbridge/utils/logging_util.dart';
import 'package:logger/logger.dart';

class Gig {
  String name;
  DateTime? date;
  String? venue;
  String? notes;

  var logger = Logger(level: LoggingUtil.loggingLevel('Gig'));

  Gig({required this.name, this.date, this.venue, this.notes});

  factory Gig.fromJson(Map<String, dynamic> json) {
    var thisGig = Gig(
      name:
          json['name'] ?? '', // Default to an empty string if 'name' is missing
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : null, // Default to null if 'date' is missing
      venue: json['venue'] ??
          '', // Default to an empty string if 'venue' is missing
      notes: json['notes'] ??
          '', // Default to an empty string if 'notes' is missing
    );

    Logger(level: LoggingUtil.loggingLevel('Gig'))
        .d('Gig.fromJson: ${thisGig.name} - ${thisGig.date.toString()}');

    return thisGig;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date!.toIso8601String(),
      'venue': venue,
      'notes': notes,
    };
  }
}
