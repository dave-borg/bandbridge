import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LokiLogOutput extends LogOutput {
  final String lokiUrl;

  LokiLogOutput(this.lokiUrl);

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      _sendLogToLoki(line, event.level);
    }
  }

  Future<void> _sendLogToLoki(String message, Level level) async {
    final logEntry = {
      'streams': [
        {
          'stream': {'level': level.toString(), 'app': 'flutter-app'},
          'values': [
            ['${DateTime.now().millisecondsSinceEpoch * 1000000}', message]
          ],
        },
      ],
    };

    final response = await http.post(
      Uri.parse(lokiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(logEntry),
    );

    if (response.statusCode != 204) {
      print('Failed to send log to Loki: ${response.body}');
    }
  }
}