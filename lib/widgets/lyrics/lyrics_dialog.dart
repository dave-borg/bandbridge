import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class LyricsDialog extends StatefulWidget {
  const LyricsDialog({Key? key}) : super(key: key);

  @override
  _LyricsDialogState createState() => _LyricsDialogState();
}

class _LyricsDialogState extends State<LyricsDialog> {
  QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Lyrics'),
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          height: 500,
          child: Column(
            children: <Widget>[
              QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  controller: _controller,
                  sharedConfigurations: const QuillSharedConfigurations(
                    locale: Locale('en'),
                  ),
                ),
              ),
              Expanded(
                child: QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                    controller: _controller,
                    sharedConfigurations: const QuillSharedConfigurations(
                      locale: Locale('en'),
                    ),
                  ),
                ),
              )
            ],
          ),
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
            // Extract the text or the rich text from the controller
            var plainText = _controller.document.toPlainText();
            // You can also serialize the document to JSON if you want to save the rich text formatting
            // var json = jsonEncode(_controller.document.toDelta().toJson());

            Navigator.of(context).pop(plainText); // Or use the JSON as needed
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Don't forget to dispose of the controller
    super.dispose();
  }
}
