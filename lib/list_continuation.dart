import 'package:flutter/services.dart';

/// Keeps a list going when Enter is pressed in it: a new item starts on the
/// next line, and Enter on an empty item ends the list. A checklist item is
/// just a paragraph that begins with a box, so this is all a checklist needs.
class ListContinuationFormatter extends TextInputFormatter {
  const ListContinuationFormatter();

  static final _numbered = RegExp(r'^(\d+)\. ');

  /// What the next item starts with, or null when [line] is not a list item.
  static String? continuationFor(String line) {
    if (line.startsWith('☐ ') || line.startsWith('☑ ')) return '☐ ';
    if (line.startsWith('• ')) return '• ';
    final number = _numbered.firstMatch(line);
    if (number != null) return '${int.parse(number.group(1)!) + 1}. ';
    return null;
  }

  /// The marker [line] starts with, or null.
  static String? markerOf(String line) {
    if (line.startsWith('☐ ') ||
        line.startsWith('☑ ') ||
        line.startsWith('• ')) {
      return line.substring(0, 2);
    }
    return _numbered.firstMatch(line)?.group(0);
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final caret = newValue.selection.baseOffset;
    final text = newValue.text;
    final isEnter = newValue.selection.isCollapsed &&
        oldValue.selection.isCollapsed &&
        text.length == oldValue.text.length + 1 &&
        caret >= 1 &&
        caret <= text.length &&
        text[caret - 1] == '\n' &&
        text.replaceRange(caret - 1, caret, '') == oldValue.text;
    if (!isEnter) return newValue;

    final newline = caret - 1;
    final lineStart = text.lastIndexOf('\n', newline - 1) + 1;
    final before = text.substring(lineStart, newline);
    final next = continuationFor(before);
    if (next == null) return newValue;

    final marker = markerOf(before)!;
    final tail = text.substring(caret);
    final tailEmptyLine = tail.isEmpty || tail.startsWith('\n');
    if (before == marker && tailEmptyLine) {
      // Enter on an empty item: the list ends here, and no new line is made.
      final ended = text.replaceRange(lineStart, caret, '');
      return TextEditingValue(
        text: ended,
        selection: TextSelection.collapsed(offset: lineStart),
      );
    }
    return TextEditingValue(
      text: text.replaceRange(caret, caret, next),
      selection: TextSelection.collapsed(offset: caret + next.length),
    );
  }
}
