import 'package:bandbridge/utils/logging_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// Fix: Make _LyricsDialogState public or make LyricsDialog constructor private
class LyricsDialog extends StatefulWidget {
  const LyricsDialog({super.key}); // Fix: Convert 'key' to a super parameter

  @override
  LyricsDialogState createState() =>
      LyricsDialogState(); // Fix: Changed _LyricsDialogState to LyricsDialogState
}

// Fix: Made LyricsDialogState public to match the public API of LyricsDialog
class LyricsDialogState extends State<LyricsDialog> {
  late TextEditingController _controller;
  var logger = Logger(level: LoggingUtil.loggingLevel('LyricsDialog'));

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(); // Initialize the TextEditingController
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Lyrics'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Text('Enter the lyrics for the song'),
            const SizedBox(height: 10),
            _buildRichTextEditor(),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            // Fix: Corrected the way to get plain text from the controller
            var plainText = _controller
                .text; // Corrected to use .text instead of .document.toPlainText()
            logger.d("Saving lyrics:/n/n$plainText");
            Navigator.of(context)
                .pop(plainText); // Use the plain text as needed
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  Widget _buildRichTextEditor() {
    return SingleChildScrollView(
      reverse: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight:
              2000.0, // Maximum height for the visible part of the text field
        ),
        child: SizedBox(
          width: 500.0,
          child: TextField(
            controller: _controller, // Fix: Assign _controller to the TextField
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 20,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter text here',
            ),
          ),
        ),
      ),
    );
  }
}
