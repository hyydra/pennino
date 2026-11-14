import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennino/quit_save.dart';

void main() {
  test('quit waits for every editor and shares repeated close requests',
      () async {
    final written = Completer<bool>();
    var calls = 0;
    Future<bool> save() {
      calls++;
      return written.future;
    }

    QuitSaveCoordinator.register(save);
    addTearDown(() => QuitSaveCoordinator.unregister(save));
    final first = QuitSaveCoordinator.saveAll();
    final second = QuitSaveCoordinator.saveAll();
    var completed = false;
    first.then((_) => completed = true);
    await Future<void>.delayed(Duration.zero);
    expect(completed, isFalse);
    expect(calls, 1);
    written.complete(true);
    expect(await first, isTrue);
    expect(await second, isTrue);
  });

  test('a failed save prevents quitting and can be retried', () async {
    var succeed = false;
    Future<bool> save() async => succeed;
    QuitSaveCoordinator.register(save);
    addTearDown(() => QuitSaveCoordinator.unregister(save));
    expect(await QuitSaveCoordinator.saveAll(), isFalse);
    succeed = true;
    expect(await QuitSaveCoordinator.saveAll(), isTrue);
  });

  test('an exception prevents quitting', () async {
    Future<bool> save() async => throw StateError('Disk unavailable');
    QuitSaveCoordinator.register(save);
    addTearDown(() => QuitSaveCoordinator.unregister(save));
    expect(await QuitSaveCoordinator.saveAll(), isFalse);
  });
}
