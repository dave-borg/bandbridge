import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:logger/logger.dart';

class LoggingUtil {
  static Level loggingLevel(String className) {
    var yaml = loadYaml(File('/Users/borg/dev/bandbridge/logging_conf.yaml')
        .readAsStringSync());
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
        level = Level.wtf;
        break;
    }

    var logger = Logger(level: level);
    logger.d('Logging level for $className: $level');

    return level;
  }
}
