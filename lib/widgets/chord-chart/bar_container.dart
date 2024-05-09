import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class BarContainer extends StatelessWidget {
  var logger = Logger(level: LoggingUtil.loggingLevel('BarContainer'));

  Widget childWidget;
  int sectionPosition;

  BarContainer(Wrap this.childWidget, this.sectionPosition, {super.key});

  @override
  Widget build(BuildContext context) {
    logger.d('BarContainer rebuilt with sectionPosition: $sectionPosition');

    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      decoration: BoxDecoration(
        border: Border(
          right: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
          left: sectionPosition == 0
              ? const BorderSide(color: Colors.black, width: 2.0)
              : BorderSide.none,
        ),
      ),
      child: childWidget,
    );
  }
}
