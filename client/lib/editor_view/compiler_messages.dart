/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *                         Copyright (C) 2014 Chuan Ji                         *
 *                             All Rights Reserved                             *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Compiler error messages and parser.
*/

part of editor_view;

// Parser for AsciiDoc compiler messages.
class AsciiDocMessageParser {
  // Parses AsciiDoc stderr output into a list of messages.
  List<_EditorMessage> parseMessages(bool success, String errorMessage) {
    List<_EditorMessage> messages = [];

    for (String line in errorMessage.split('\n')) {
      _EditorMessage message = new _EditorMessage();
      message.text = line.replaceAllMapped(
          _ERROR_MESSAGE_RE, (Match m) => m[1]);
      if (message.text.isEmpty) {
        continue;
      }
      message.type = success ? _EditorMessage.WARNING : _EditorMessage.ERROR;
      try {
        message.lineNumber = int.parse(
            message.text.replaceAllMapped(
                _ERROR_MESSAGE_LINE_NUMBER_RE, (Match m) => m[1]));
      } on FormatException catch (e) {
        _log.finest('Could not parse line number from message: ${e}');
      }
      // Capitalize first character in line.
      message.text = message.text.substring(0, 1).toUpperCase() +
          message.text.substring(1);

      messages.add(message);
    }

    return messages;
  }


  // Logger.
  final Logger _log = new Logger('AsciiDocMessageParser');

  // Regular expression for extracting message to be displayed from a raw error
  // message.
  static final RegExp _ERROR_MESSAGE_RE =
      new RegExp(r'^(?:[^:]+:\s+){3}(.*)$');
  // Regular expression for extracting the line number from an error message.
  static final RegExp _ERROR_MESSAGE_LINE_NUMBER_RE =
      new RegExp(r'^line\s+(\d+):.*$');
}
