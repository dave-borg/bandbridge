
import 'package:flutter/material.dart';

class SectionScrollItem extends StatelessWidget {
  final String displayText;
  final bool isHeader;

  const SectionScrollItem({
    Key? key,
    required this.displayText,
    required this.isHeader}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      isHeader ? "[ " + displayText.toUpperCase() + " ]": displayText,
      style: TextStyle(
        fontSize: isHeader ? 36 : 28,
        fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        color: isHeader ? Color.fromARGB(255, 175, 166, 226) : Colors.white,
      ),
    );
  }
}