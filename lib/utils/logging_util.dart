// ignore_for_file: deprecated_member_use
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';
import 'package:logger/logger.dart';

class LoggingUtil {
  static YamlMap? _yamlCache;
  // Method to preload YAML content asynchronously
  static Future<void> preloadYamlContent(doc) async {
    final yamlString = await rootBundle.loadString('assets/logging_conf.yaml');
    _yamlCache = loadYaml(yamlString);
  }

  static Level loggingLevel(String className) {
    if (_yamlCache == null) {
      throw Exception(
          'YAML content not preloaded. Call preloadYamlContent first.');
    }
    var yaml = _yamlCache!;
    var level = Level.info;

    // If the class name is not in the loggers section of the YAML file, use the DEFAULT logger
    if (!yaml['loggers'].containsKey(className)) className = 'DEFAULT';
    if (yaml['loggers'][className] == null) return level;

    switch (yaml['loggers'][className]['level']) {
      case 'DEBUG':
        level = Level.debug;
        break;
      case 'ERROR':
        level = Level.error;
        break;
      case 'INFO':
        level = Level.info;
        break;
      case 'NOTHING':
        level = Level.nothing;
        break;
      case 'VERBOSE':
        level = Level.verbose;
        break;
      case 'WARNING':
        level = Level.warning;
        break;
      case 'WTF':
        level = Level.wtf; //new favorite thing
        break;
    }

    return level;
  }
}
