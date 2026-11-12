import 'package:flutter/services.dart';

typedef QuitSave = Future<bool> Function();

/// All mounted editors must finish saving before a native or update exit.
class QuitSaveCoordinator {
  static const channel = MethodChannel('notes/quit');
  static final Set<QuitSave> _editors = {};
  static Future<bool>? _pending;

  static void initialize() {
    channel.setMethodCallHandler((call) async {
      if (call.method == 'prepareToQuit') return saveAll();
      throw MissingPluginException();
    });
  }

  static void register(QuitSave save) => _editors.add(save);
  static void unregister(QuitSave save) => _editors.remove(save);

  static Future<bool> saveAll() async {
    final pending = _pending;
    if (pending != null) return pending;
    final operation = _saveAll();
    _pending = operation;
    try {
      return await operation;
    } finally {
      _pending = null;
    }
  }

  static Future<bool> _saveAll() async {
    try {
      for (final save in _editors.toList().reversed) {
        if (!await save()) return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
