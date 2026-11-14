import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennino/drive_sync_service.dart';
import 'package:pennino/main.dart';
import 'package:pennino/note_data.dart';
import 'package:pennino/note_store.dart';

class MemoryNoteStore extends NoteStore {
  final Map<String, Note> notes;

  MemoryNoteStore(Note note)
      : notes = {note.id: note},
        super(directoryProvider: () async => Directory.systemTemp);

  @override
  Future<List<Note>> load() async => notes.values.toList();

  @override
  Future<Map<String, NoteTombstone>> tombstones() async => {};

  @override
  Future<void> save(Note note) async {
    notes[note.id] = note;
  }

  @override
  Future<Note> saveIfNewer(Note note) async {
    final current = notes[note.id];
    if (current != null && current.updated.isAfter(note.updated)) {
      return current;
    }
    notes[note.id] = note;
    return note;
  }
}

class PausedDriveSyncService extends DriveSyncService {
  final syncStarted = Completer<void>();
  final result = Completer<DriveSyncResult?>();

  PausedDriveSyncService(NoteStore store) : super(store: store, backend: null);

  @override
  Future<DriveSyncResult?> sync({
    bool chooseFolder = false,
    String? currentNoteId,
  }) {
    syncStarted.complete();
    return result.future;
  }
}

void main() {
  testWidgets('manual sync keeps edits made while Drive is responding',
      (tester) async {
    final note = Note(
      id: 'manual-sync',
      title: 'Before sync',
      updated: DateTime.utc(2026, 11, 14),
      strokes: [],
    );
    final syncedNote = Note(
      id: note.id,
      title: 'Remote title',
      updated: DateTime.utc(2026, 11, 15),
      strokes: [],
    );
    final syncService = PausedDriveSyncService(MemoryNoteStore(note));
    final directory = await tester.runAsync(
      () => Directory.systemTemp.createTemp('manual-sync-test-'),
    );
    expect(directory, isNotNull);
    addTearDown(() => directory!.delete(recursive: true));

    final editorKey = GlobalKey<State<EditorPage>>();
    await tester.binding.setSurfaceSize(const Size(900, 740));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: EditorPage(
          key: editorKey,
          note: note,
          directoryProvider: () async => directory!,
          syncService: syncService,
        ),
      ),
    );
    await tester.pump();

    final dynamic editor = editorKey.currentState;
    final TextEditingController titleController =
        editor.titleController as TextEditingController;
    await tester.runAsync(
      () => (editor.autosave.saveNow() as Future<void>)
          .timeout(const Duration(seconds: 10)),
    );
    final syncOperation = editor.syncDrive(chooseFolder: true) as Future<void>;
    await tester.pump();
    await syncService.syncStarted.future;

    titleController.text = 'Edited during sync';
    await tester.pump();
    syncService.result.complete(DriveSyncResult(currentNote: syncedNote));
    await tester.pump();
    await syncOperation;

    expect(titleController.text, 'Edited during sync');
    expect(note.title, 'Before sync');
  });
}
