import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennino/note_data.dart';
import 'package:pennino/rich_text_controller.dart';

void main() {
  test('selected text style is retained and follows edits', () {
    final styles = <TextStyleRange>[];
    final controller = RichTextEditingController(
      text: 'Pennino notes',
      styles: styles,
    );
    addTearDown(controller.dispose);

    controller.applyStyle(
      const TextSelection(baseOffset: 0, extentOffset: 7),
      bold: true,
      fontSize: 30,
    );

    expect(styles.single.start, 0);
    expect(styles.single.end, 7);
    expect(styles.single.bold, isTrue);
    expect(styles.single.fontSize, 30);

    controller.value = const TextEditingValue(text: 'My Pennino notes');
    expect(styles.single.start, 3);
    expect(styles.single.end, 10);
  });

  test('style ranges remain attached across boundary insertion and deletion',
      () {
    final style = TextStyleRange(start: 2, end: 6, bold: true);
    final controller = RichTextEditingController(
      text: 'abcdefgh',
      styles: [style],
    );
    addTearDown(controller.dispose);

    controller.value = const TextEditingValue(text: 'abXYcdefgh');
    expect((style.start, style.end), (4, 8));

    controller.value = const TextEditingValue(text: 'abXYdefgh');
    expect((style.start, style.end), (4, 7));
  });

  testWidgets('selected text builds separate rich spans', (tester) async {
    final controller = RichTextEditingController(
      text: 'gold ink',
      styles: [
        TextStyleRange(start: 0, end: 4, bold: true, color: 0xffd7a842),
      ],
    );
    addTearDown(controller.dispose);
    late BuildContext context;
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (value) {
        context = value;
        return const SizedBox();
      }),
    ));

    final span = controller.buildTextSpan(
      context: context,
      style: const TextStyle(fontSize: 20),
      withComposing: false,
    );
    final children = span.children!.cast<TextSpan>();
    expect(children.first.text, 'gold');
    expect(children.first.style!.fontWeight, FontWeight.bold);
    expect(children.first.style!.color, const Color(0xffd7a842));
    expect(children.last.text, ' ink');
  });

  testWidgets('overlapping ranges merge attributes with later precedence',
      (tester) async {
    final controller = RichTextEditingController(
      text: 'abcdefgh',
      styles: [
        TextStyleRange(start: 0, end: 5, bold: true, color: 0xffd7a842),
        TextStyleRange(start: 3, end: 8, fontSize: 26),
        TextStyleRange(start: 4, end: 6, bold: false),
      ],
    );
    addTearDown(controller.dispose);
    late BuildContext context;
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (value) {
        context = value;
        return const SizedBox();
      }),
    ));

    final span = controller.buildTextSpan(
      context: context,
      style: const TextStyle(fontSize: 16),
      withComposing: false,
    );
    final children = span.children!.cast<TextSpan>();

    expect(children.map((child) => child.text).join(), 'abcdefgh');
    expect(children[0].style!.fontWeight, FontWeight.bold);
    expect(children[0].style!.color, const Color(0xffd7a842));
    expect(children[1].style!.fontSize, 26);
    expect(children[2].style!.fontWeight, FontWeight.normal);
    expect(children[2].style!.fontSize, 26);
    expect(children[2].style!.color, const Color(0xffd7a842));
    expect(children[3].style!.fontWeight, FontWeight.normal);
    expect(children[3].style!.color, isNull);
    expect(children.last.style!.fontSize, 26);
  });

  testWidgets('checklist marks are icons in the live editor and text elsewhere',
      (tester) async {
    final controller = RichTextEditingController(
      text: '☐ milk\n☑ eggs\nplain ☐ not a mark',
      styles: <TextStyleRange>[],
    );
    addTearDown(controller.dispose);
    late BuildContext context;
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (c) {
        context = c;
        return const SizedBox();
      }),
    ));
    const style = TextStyle(color: Color(0xffd0d0d0), fontSize: 20);

    final live = controller.buildTextSpan(
      context: context,
      style: style,
      withComposing: true,
    );
    final widgets = <WidgetSpan>[];
    live.visitChildren((span) {
      if (span is WidgetSpan) widgets.add(span);
      return true;
    });
    expect(widgets, hasLength(2),
        reason: 'only a mark at the line start counts');
    final icon = widgets.first.child as Icon;
    expect(icon.color, style.color, reason: 'a tick takes the text colour');
    // A widget stands in for exactly one character, so offsets do not move.
    expect(live.toPlainText(includePlaceholders: true).length,
        controller.text.length);

    final offscreen = controller.buildTextSpan(
      context: context,
      style: style,
      withComposing: false,
    );
    var hasWidget = false;
    offscreen.visitChildren((span) {
      if (span is WidgetSpan) hasWidget = true;
      return true;
    });
    expect(hasWidget, isFalse, reason: 'off-screen layout keeps the text');
    expect(offscreen.toPlainText(), controller.text);
  });
}
