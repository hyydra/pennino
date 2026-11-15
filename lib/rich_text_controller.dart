import 'package:flutter/material.dart';

import 'note_data.dart';

class RichTextEditingController extends TextEditingController {
  final List<TextStyleRange> styles;

  RichTextEditingController({
    required String text,
    required this.styles,
  }) : super(text: text);

  @override
  set value(TextEditingValue nextValue) {
    if (nextValue.text != text) {
      _adjustRanges(text, nextValue.text);
    }
    super.value = nextValue;
  }

  void applyStyle(
    TextSelection selection, {
    bool? bold,
    int? color,
    double? fontSize,
  }) {
    if (!selection.isValid || selection.isCollapsed) return;
    final start = selection.start.clamp(0, text.length);
    final end = selection.end.clamp(0, text.length);
    if (start >= end) return;
    styles.add(TextStyleRange(
      start: start,
      end: end,
      bold: bold,
      color: color,
      fontSize: fontSize,
    ));
    notifyListeners();
  }

  bool? selectedBold(TextSelection selection) {
    if (!selection.isValid || selection.isCollapsed) return null;
    bool? result;
    for (final range in styles) {
      if (range.bold != null &&
          range.start < selection.end &&
          range.end > selection.start) {
        result = range.bold;
      }
    }
    return result;
  }

  void _adjustRanges(String oldText, String newText) {
    var prefix = 0;
    final shortest = mathMin(oldText.length, newText.length);
    while (prefix < shortest && oldText[prefix] == newText[prefix]) {
      prefix++;
    }
    var suffix = 0;
    while (suffix < oldText.length - prefix &&
        suffix < newText.length - prefix &&
        oldText[oldText.length - suffix - 1] ==
            newText[newText.length - suffix - 1]) {
      suffix++;
    }
    final oldEnd = oldText.length - suffix;
    final insertedLength = newText.length - prefix - suffix;
    final delta = newText.length - oldText.length;

    for (final range in styles) {
      range.start = _mapOffset(
        range.start,
        prefix: prefix,
        oldEnd: oldEnd,
        insertedLength: insertedLength,
        delta: delta,
        endAffinity: false,
      );
      range.end = _mapOffset(
        range.end,
        prefix: prefix,
        oldEnd: oldEnd,
        insertedLength: insertedLength,
        delta: delta,
        endAffinity: true,
      );
    }
    styles.removeWhere((range) => range.start >= range.end);
  }

  int _mapOffset(
    int offset, {
    required int prefix,
    required int oldEnd,
    required int insertedLength,
    required int delta,
    required bool endAffinity,
  }) {
    if (oldEnd == prefix && offset == prefix) {
      return offset + insertedLength;
    }
    if (offset < prefix || (!endAffinity && offset == prefix)) return offset;
    if (offset > oldEnd || (endAffinity && offset == oldEnd)) {
      return offset + delta;
    }
    return endAffinity ? prefix + insertedLength : prefix;
  }

  /// A checklist mark is a ballot-box character in the text, and a font may
  /// paint it as a coloured emoji - the blue tick that ignored the text style.
  /// While the field is being edited the mark is drawn as an icon in the
  /// text's own colour and size instead. It stands in for exactly one
  /// character, so offsets and the caret do not move. Layout done off screen
  /// (`withComposing: false`) keeps the plain characters.
  bool _isTickAt(int index) =>
      (text[index] == '\u2610' || text[index] == '\u2611') &&
      index + 1 < text.length &&
      text[index + 1] == ' ' &&
      (index == 0 || text[index - 1] == '\n');

  List<InlineSpan> _spansFor(
    int start,
    int end,
    TextStyle? style,
    bool inlineTicks,
  ) {
    if (!inlineTicks) {
      return [TextSpan(text: text.substring(start, end), style: style)];
    }
    final spans = <InlineSpan>[];
    var plainStart = start;
    for (var index = start; index < end; index++) {
      if (!_isTickAt(index)) continue;
      if (index > plainStart) {
        spans.add(TextSpan(
          text: text.substring(plainStart, index),
          style: style,
        ));
      }
      final size = (style?.fontSize ?? 14) * 1.15;
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Icon(
          text[index] == '\u2611'
              ? Icons.check_box_outlined
              : Icons.check_box_outline_blank,
          size: size,
          color: style?.color,
        ),
      ));
      plainStart = index + 1;
    }
    if (plainStart < end) {
      spans.add(TextSpan(text: text.substring(plainStart, end), style: style));
    }
    return spans;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (text.isEmpty) return TextSpan(style: style, text: text);
    if (styles.isEmpty) {
      return TextSpan(
        style: style,
        children: _spansFor(0, text.length, style, withComposing),
      );
    }
    final boundaries = <int>{0, text.length};
    for (final range in styles) {
      boundaries
        ..add(range.start.clamp(0, text.length))
        ..add(range.end.clamp(0, text.length));
    }
    final sorted = boundaries.toList()..sort();
    final children = <InlineSpan>[];
    for (var index = 0; index < sorted.length - 1; index++) {
      final start = sorted[index];
      final end = sorted[index + 1];
      if (start == end) continue;
      var segmentStyle = style;
      for (final range in styles) {
        if (range.start >= end || range.end <= start) continue;
        segmentStyle = segmentStyle?.copyWith(
          fontWeight: range.bold == null
              ? null
              : range.bold!
                  ? FontWeight.bold
                  : FontWeight.normal,
          color: range.color == null ? null : Color(range.color!),
          fontSize: range.fontSize,
        );
      }
      children.addAll(_spansFor(start, end, segmentStyle, withComposing));
    }
    return TextSpan(style: style, children: children);
  }
}

int mathMin(int first, int second) => first < second ? first : second;
