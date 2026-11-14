import 'dart:math' as math;

import 'package:flutter/material.dart';

enum DrawTool {
  hand,
  text,
  pencil,
  pen,
  highlighter,
  eraser,
  blur,
}

class DrawingToolIcon extends StatelessWidget {
  final DrawTool tool;
  final double size;

  const DrawingToolIcon(this.tool, {super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    final color =
        IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurface;
    if (tool == DrawTool.text) {
      return CustomPaint(
        key: const ValueKey('drawing-tool-icon-text'),
        size: Size.square(size),
        painter: TextToolIconPainter(color),
      );
    }
    if (tool == DrawTool.eraser) {
      return CustomPaint(
        key: const ValueKey('drawing-tool-icon-eraser'),
        size: Size.square(size),
        painter: EraserToolIconPainter(
          color,
          Theme.of(context).colorScheme.primary,
        ),
      );
    }
    return Icon(_toolIconData(tool), size: size);
  }

  IconData _toolIconData(DrawTool tool) => switch (tool) {
        DrawTool.hand => Icons.pan_tool_outlined,
        DrawTool.text => Icons.title,
        DrawTool.pencil => Icons.create_outlined,
        DrawTool.pen => Icons.edit,
        DrawTool.highlighter => Icons.border_color,
        DrawTool.eraser => Icons.backspace_outlined,
        DrawTool.blur => Icons.blur_on,
      };
}

class TextToolIconPainter extends CustomPainter {
  final Color color;

  const TextToolIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.shortestSide * 0.11
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.26),
      Offset(size.width * 0.8, size.height * 0.26),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.26),
      Offset(size.width * 0.5, size.height * 0.78),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant TextToolIconPainter oldDelegate) =>
      color != oldDelegate.color;
}

class FontSizeMarkIcon extends StatelessWidget {
  const FontSizeMarkIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final color =
        IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurface;
    return CustomPaint(
      key: key,
      size: const Size.square(24),
      painter: FontSizeMarkIconPainter(color),
    );
  }
}

class FontSizeMarkIconPainter extends CustomPainter {
  final Color color;

  const FontSizeMarkIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.shortestSide * 0.1
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(
      Offset(size.width * 0.05, size.height * 0.25),
      Offset(size.width * 0.45, size.height * 0.25),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.25),
      Offset(size.width * 0.25, size.height * 0.78),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.68, size.height * 0.36),
      Offset(size.width * 0.68, size.height * 0.78),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.54, size.height * 0.50),
      Offset(size.width * 0.85, size.height * 0.50),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant FontSizeMarkIconPainter oldDelegate) =>
      color != oldDelegate.color;
}

class EraserToolIconPainter extends CustomPainter {
  final Color color;
  final Color accentColor;

  const EraserToolIconPainter(this.color, this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final body = Rect.fromCenter(
      center: Offset.zero,
      width: size.shortestSide * 0.76,
      height: size.shortestSide * 0.40,
    );
    final rubber = RRect.fromRectAndRadius(
      body,
      Radius.circular(size.shortestSide * 0.055),
    );
    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..rotate(-math.pi / 4);
    canvas.drawRRect(
      rubber,
      Paint()..color = color.withValues(alpha: 0.16),
    );
    canvas.save();
    canvas.clipRRect(rubber);
    canvas.drawRect(
      Rect.fromLTRB(body.left, body.top, 0, body.bottom),
      Paint()..color = accentColor.withValues(alpha: 0.48),
    );
    canvas.restore();
    final outline = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.09
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas.drawRRect(rubber, outline);
    canvas.drawLine(
      Offset(0, body.top),
      Offset(0, body.bottom),
      outline,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant EraserToolIconPainter oldDelegate) =>
      color != oldDelegate.color || accentColor != oldDelegate.accentColor;
}
