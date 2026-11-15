import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennino/main.dart';
import 'package:pennino/note_data.dart';

Note canvasNote({String text = ''}) => Note(
      id: 'canvas-pan-note',
      title: 'Pan',
      updated: DateTime.utc(2026, 11, 14),
      text: text,
      strokes: [],
      pageCount: 3,
    );

Future<void> openEditor(WidgetTester tester, {String text = ''}) async {
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1000, 900);
  await tester.pumpWidget(MaterialApp(
    theme: ThemeData(platform: TargetPlatform.android),
    home: EditorPage(note: canvasNote(text: text)),
  ));
  await tester.pumpAndSettle();
}

Future<void> pickTool(WidgetTester tester, String tooltip) async {
  final byTip = find.byTooltip(tooltip);
  if (byTip.evaluate().isEmpty) return;
  await tester.tap(byTip, warnIfMissed: false);
  await tester.pumpAndSettle();
}

Finder get paperStack => find.byKey(const Key('canvas-layer-stack'));

Offset paperTopLeft(WidgetTester tester) => tester.getTopLeft(paperStack);

IconButton undoButton(WidgetTester tester) => tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.undo),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('one finger pans the paper in text mode', (tester) async {
    await openEditor(tester);
    final before = paperTopLeft(tester);
    final gesture = await tester.startGesture(before + const Offset(200, 200));
    await gesture.moveBy(const Offset(-30, -80));
    await tester.pump();
    final during = paperTopLeft(tester);
    await gesture.up();
    await tester.pumpAndSettle();

    expect(
      during - before,
      const Offset(0, -80),
      reason: 'a finger moves the paper up by its own delta, and the '
          'paper is as wide as the view, so it never moves sideways',
    );
    expect(
      undoButton(tester).onPressed,
      isNull,
      reason: 'a pan is not a mark, so there is nothing to undo',
    );
  });

  testWidgets('a drawing wider than the view keeps its width and pans sideways',
      (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(500, 900);
    final note = Note(
      id: 'wide-raster-note',
      title: 'Wide',
      updated: DateTime.utc(2026, 11, 15),
      text: '',
      strokes: [],
      pageCount: 3,
      rasterWidth: 1400,
      rasterPageHeight: 1200,
    );
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(platform: TargetPlatform.android),
      home: EditorPage(note: note),
    ));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(paperStack).width,
      1400,
      reason: 'ink drawn on a wider screen must not be cut off by this one',
    );
    final before = paperTopLeft(tester);
    final gesture = await tester.startGesture(before + const Offset(300, 200));
    await gesture.moveBy(const Offset(-300, 0));
    await tester.pump();
    final during = paperTopLeft(tester);
    await gesture.up();
    await tester.pumpAndSettle();

    expect(
      during - before,
      const Offset(-300, 0),
      reason: 'the far side of a wide drawing is reached by panning',
    );
  });

  testWidgets('the paper cannot be pulled past its top edge', (tester) async {
    await openEditor(tester);
    final before = paperTopLeft(tester);
    final gesture = await tester.startGesture(before + const Offset(200, 200));
    await gesture.moveBy(const Offset(25, 120));
    await tester.pump();
    final during = paperTopLeft(tester);
    await gesture.up();
    await tester.pumpAndSettle();

    expect(
      during,
      before,
      reason: 'the top of the paper is a hard stop, in both directions',
    );
  });

  testWidgets('the pen draws with one finger and leaves the paper in place',
      (tester) async {
    await openEditor(tester);
    await pickTool(tester, 'Pen');
    final before = paperTopLeft(tester);
    final gesture = await tester.startGesture(before + const Offset(600, 150));
    await gesture.moveBy(const Offset(40, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(40, 10));
    await tester.pump();
    final during = paperTopLeft(tester);
    await gesture.up();
    await tester.pumpAndSettle();

    expect(
      during,
      before,
      reason: 'the pen marks the paper instead of moving it',
    );
    expect(
      undoButton(tester).onPressed,
      isNotNull,
      reason: 'the pen leaves a mark that undo can take back',
    );
  });

  testWidgets('a press on a line of text opens the inline editor',
      (tester) async {
    await openEditor(tester, text: 'one');
    final before = paperTopLeft(tester);
    // The first line starts at the paper margin, well inside the view.
    final gesture = await tester.startGesture(before + const Offset(70, 60));
    await gesture.moveBy(const Offset(0, -60));
    await tester.pump();
    final during = paperTopLeft(tester);
    await gesture.up();
    await tester.pumpAndSettle();

    expect(during, before, reason: 'a press on a letter edits, it never pans');
    expect(
      find.byKey(const Key('text-toolbar')),
      findsOneWidget,
      reason: 'the text toolbar is the sign the editor is on',
    );
  });

  testWidgets('every visible line of a long note opens the editor when pressed',
      (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(420, 900);
    final note = Note(
      id: 'long-note',
      title: 'Long',
      updated: DateTime.utc(2026, 11, 15),
      text: List.generate(
        12,
        (i) => 'Line number $i of the note, long enough to wrap onto more rows',
      ).join('\n'),
      strokes: [],
      pageCount: 3,
    );
    Widget app() => MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: EditorPage(note: note),
        );
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    RenderEditable? editable;
    void visit(RenderObject node) {
      if (editable == null && node is RenderEditable) editable = node;
      node.visitChildren(visit);
    }

    visit(tester.renderObject(find.byType(EditableText).first));
    final field = editable!;
    final boxes = field.getBoxesForSelection(
      TextSelection(baseOffset: 0, extentOffset: field.plainText.length),
    );
    final centres = <Offset>[];
    var lastTop = -1.0;
    for (final box in boxes) {
      if ((box.top - lastTop).abs() <= 1) continue;
      lastTop = box.top;
      final centre = field.localToGlobal(box.toRect().center);
      if (centre.dy < 800) centres.add(centre);
    }
    expect(centres.length, greaterThan(10));

    final missed = <int>[];
    for (var i = 0; i < centres.length; i++) {
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      final gesture = await tester.startGesture(centres[i]);
      await gesture.up();
      await tester.pumpAndSettle();
      if (find.byKey(const Key('text-toolbar')).evaluate().isEmpty) {
        missed.add(i);
      }
    }
    expect(missed, isEmpty, reason: 'a visible line did not take the press');
  });

  testWidgets('a press on blank paper drags it until a drawing tool is picked',
      (tester) async {
    await openEditor(tester, text: 'one');
    final before = paperTopLeft(tester);
    final gesture = await tester.startGesture(before + const Offset(600, 300));
    await gesture.moveBy(const Offset(0, -70));
    await tester.pump();
    final during = paperTopLeft(tester);
    await gesture.up();
    await tester.pumpAndSettle();

    expect(during - before, const Offset(0, -70));
    expect(
      undoButton(tester).onPressed,
      isNull,
      reason: 'with no tool in hand a drag is not a mark',
    );
  });

  testWidgets('choosing the active drawing tool again puts it down',
      (tester) async {
    await openEditor(tester);
    await pickTool(tester, 'Pen');
    await pickTool(tester, 'Pen');
    final before = paperTopLeft(tester);
    final gesture = await tester.startGesture(before + const Offset(600, 300));
    await gesture.moveBy(const Offset(0, -50));
    await tester.pump();
    final during = paperTopLeft(tester);
    await gesture.up();
    await tester.pumpAndSettle();

    expect(during - before, const Offset(0, -50));
  });

  testWidgets('the page number stays in the view top-left as the paper moves',
      (tester) async {
    await openEditor(tester);
    final indicator = find.byKey(const Key('page-indicator'));
    expect(indicator, findsOneWidget);
    expect(find.text('1/3'), findsOneWidget);

    final stack = paperTopLeft(tester);
    final chip = tester.getTopLeft(indicator);
    expect(
      chip - stack,
      const Offset(12, 12),
      reason: 'the chip is inset from the view, not drawn on the paper',
    );

    final dividerTop =
        tester.getTopLeft(find.byKey(const ValueKey('page-divider-1'))).dy;
    final pageHeight = dividerTop - stack.dy + 7;

    final gesture = await tester.startGesture(stack + const Offset(200, 200));
    await gesture.moveBy(Offset(0, -pageHeight));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(
      paperTopLeft(tester).dy,
      closeTo(stack.dy - pageHeight, 0.5),
      reason: 'the drag panned exactly one page',
    );
    expect(
      tester.getTopLeft(indicator),
      chip,
      reason: 'the chip does not scroll with the paper',
    );
    expect(find.text('2/3'), findsOneWidget);
  });
}
