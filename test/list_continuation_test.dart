import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennino/list_continuation.dart';

TextEditingValue at(String text, int caret) => TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: caret),
    );

/// Types a newline at [caret] in [text] and returns what the formatter makes.
TextEditingValue enter(String text, int caret) =>
    const ListContinuationFormatter().formatEditUpdate(
      at(text, caret),
      at(text.replaceRange(caret, caret, '\n'), caret + 1),
    );

void main() {
  test('Enter at the end of a checklist item starts an unchecked item', () {
    final result = enter('☐ milk', 6);
    expect(result.text, '☐ milk\n☐ ');
    expect(result.selection.baseOffset, 9);
  });

  test('a ticked item continues with an empty box', () {
    expect(enter('☑ milk', 6).text, '☑ milk\n☐ ');
  });

  test('Enter on an empty item ends the list', () {
    final result = enter('☐ milk\n☐ ', 9);
    expect(result.text, '☐ milk\n');
    expect(result.selection.baseOffset, 7);
  });

  test('a bullet and a numbered item continue too', () {
    expect(enter('• one', 5).text, '• one\n• ');
    expect(enter('1. one', 6).text, '1. one\n2. ');
    expect(enter('9. nine', 7).text, '9. nine\n10. ');
  });

  test('Enter in the middle of an item moves the tail into the next one', () {
    final result = enter('☐ buy milk', 5);
    expect(result.text, '☐ buy\n☐  milk');
    expect(result.selection.baseOffset, 8);
  });

  test('plain paragraphs and other edits are left alone', () {
    expect(enter('just text', 9).text, 'just text\n');
    const formatter = ListContinuationFormatter();
    final typed = formatter.formatEditUpdate(at('☐ a', 3), at('☐ ab', 4));
    expect(typed.text, '☐ ab');
  });
}
