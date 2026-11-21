import 'dart:async';
import 'dart:io';

/// Append-only diagnostic log for Drive sync, written to `sync.log` beside the
/// notes. It stays off (every call is a no-op) until [enable] is called, so
/// tests and platforms without a note folder never touch the disk.
///
/// The log never contains note content, only file names, sizes, counts and
/// error text. When it passes [maxBytes] the previous log is kept as
/// `sync.log.1` and a fresh one is started.
class SyncLog {
  static const maxBytes = 512 * 1024;

  static File? _file;
  static Future<void> _tail = Future<void>.value();

  static bool get isEnabled => _file != null;

  /// The log file, or null while logging is off.
  static String? get path => _file?.path;

  static void enable(Directory directory) {
    _file = File('${directory.path}${Platform.pathSeparator}sync.log');
  }

  static void disable() => _file = null;

  static void log(String message) {
    final file = _file;
    if (file == null) return;
    final line = '${DateTime.now().toUtc().toIso8601String()} $message\n';
    _tail = _tail.catchError((_) {}).then((_) async {
      try {
        if (await file.exists() && await file.length() > maxBytes) {
          final old = File('${file.path}.1');
          if (await old.exists()) await old.delete();
          await file.rename(old.path);
        }
        await file.writeAsString(line, mode: FileMode.append, flush: true);
      } catch (_) {
        // Logging must never be the reason a sync or a save fails.
      }
    });
  }

  static void error(String message, Object error, [StackTrace? stackTrace]) {
    log('ERROR $message: $error');
    if (stackTrace != null) log('STACK $stackTrace');
  }

  /// Completes once every line logged so far has been written. For tests.
  static Future<void> flush() => _tail.catchError((_) {});
}
