import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennino/main.dart';
import 'package:pennino/note_data.dart';
import 'package:pennino/pennino_theme.dart';

Note layoutNote() => Note(
      id: 'layout-note',
      title: 'Layout',
      updated: DateTime.utc(2026, 11, 10),
      text: 'one\ntwo\nthree\nfour',
      strokes: [],
    );

Future<void> openEditor(
  WidgetTester tester, {
  required Size size,
  double keyboard = 0,
}) async {
  addTearDown(() {
    tester.view.viewInsets = FakeViewPadding();
    tester.view.resetPhysicalSize();
  });
  tester.view.devicePixelRatio = 1;
  // `setSurfaceSize` only constrains layout: MediaQuery keeps reporting the
  // 2400x1800 test default, so the app bar read itself as wide while the
  // screen was 240 - a pairing no device can produce. Setting the view size
  // moves the constraints and MediaQuery together.
  tester.view.physicalSize = size;
  if (keyboard > 0) {
    tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
  }
  await tester.pumpWidget(MaterialApp(
    theme: ThemeData(platform: TargetPlatform.android),
    home: EditorPage(note: layoutNote()),
  ));
  await tester.pumpAndSettle();
  // Text is the resting tool and shows only its own row; these tests are
  // about the ink row, so start with a pen in hand.
  await pickTool(tester, 'Drawing tools');
}

Future<void> pickTool(WidgetTester tester, String tooltip) async {
  final byTip = find.byTooltip(tooltip);
  if (byTip.evaluate().isEmpty) return;
  await tester.tap(byTip, warnIfMissed: false);
  await tester.pumpAndSettle();
}

/// The bordered square each ink button paints inside.
List<Size> inkChips(WidgetTester tester) {
  final out = <Size>[];
  final chips = find.descendant(
    of: find.byKey(const Key('android-drawing-toolbar')),
    matching: find.byType(DecoratedBox),
  );
  for (final element in chips.evaluate()) {
    final box = element.renderObject;
    if (box is! RenderBox || !box.hasSize) continue;
    out.add(box.size);
  }
  return out;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the theme colours the roles its widgets ask for', () {
    final scheme = buildPenninoTheme().colorScheme;
    // A container role the theme leaves out comes back as the base colour
    // beside it, so the update row - which asks for `secondaryContainer` -
    // was painting in the light steel of `secondary`.
    expect(
      scheme.secondaryContainer,
      isNot(same(scheme.secondary)),
      reason: 'the update row needs its own container tone',
    );
    expect(
      scheme.onSecondaryContainer,
      isNot(same(scheme.onSecondary)),
      reason: 'its text needs the matching foreground tone',
    );
  });

  testWidgets('ink chips keep the square they ask for', (tester) async {
    await openEditor(tester, size: const Size(390, 844));
    final chips = inkChips(tester);
    expect(chips, isNotEmpty);
    for (final chip in chips) {
      expect(
        chip.width,
        closeTo(chip.height, 0.5),
        reason: 'a $chip chip is a squashed rectangle, not a square',
      );
    }
    // The design asks for 32 on a screen this wide; the slots used to hand
    // the chip only what the button's own padding left over.
    expect(chips.first.width, greaterThanOrEqualTo(30));
  });

  testWidgets('a narrow screen keeps every ink tool tappable', (tester) async {
    await openEditor(tester, size: const Size(240, 600));
    expect(tester.takeException(), isNull);
    for (final tool in const [
      'Text',
      'Pencil',
      'Pen',
      'Highlighter',
      'Eraser',
      'Blur'
    ]) {
      final cell = find.byTooltip(tool);
      expect(cell, findsOneWidget, reason: '$tool left the toolbar');
      expect(
        tester.getRect(cell).width,
        greaterThanOrEqualTo(34),
        reason: '$tool is too small to hit',
      );
    }
  });

  testWidgets('landscape with the keyboard up keeps the ink row',
      (tester) async {
    await openEditor(tester, size: const Size(800, 360), keyboard: 200);
    expect(tester.takeException(), isNull);
    final chip = tester.getRect(find.byTooltip('Pen'));
    expect(chip.bottom, lessThanOrEqualTo(360));
    expect(chip.top, greaterThanOrEqualTo(0));
  });

  testWidgets('landscape with the keyboard up keeps the text row',
      (tester) async {
    await openEditor(tester, size: const Size(800, 360), keyboard: 200);
    await pickTool(tester, 'Text');
    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('text-toolbar')), findsOneWidget);
    final toolbar = tester.getRect(find.byKey(const Key('text-toolbar')));
    expect(toolbar.bottom, lessThanOrEqualTo(360));
  });

  testWidgets('a short screen with the keyboard up keeps the text row',
      (tester) async {
    await openEditor(tester, size: const Size(240, 400), keyboard: 260);
    await pickTool(tester, 'Text');
    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('text-toolbar')), findsOneWidget);
  });
}
