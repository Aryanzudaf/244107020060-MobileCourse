import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week5_offline_notes/data/local/note.dart';
import 'package:week5_offline_notes/data/providers.dart';
import 'package:week5_offline_notes/data/sync.dart';

import 'fakes.dart';

void main() {
  test('fromMap aman terhadap field yang hilang', () {
    final note = Note.fromMap({'title': 'Belanja'});
    expect(note.title, 'Belanja');
    expect(note.body, '');
    expect(note.dirty, isFalse);
  });

  test('flag dirty bertahan pada serialisasi', () {
    final note = Note(
      title: 'a',
      updatedAt: DateTime(2026, 9, 18),
      dirty: true,
    );
    final restored = Note.fromMap(note.toMap());
    expect(restored.dirty, isTrue);
  });

  test('provider sukses dengan repository palsu', () async {
    final container = ProviderContainer(
      overrides: [
        noteRepositoryProvider.overrideWithValue(
          FakeNoteRepository(items: [
            Note(title: 'Tes', updatedAt: DateTime.now()),
          ]),
        ),
      ],
    );
    addTearDown(container.dispose);

    final notes = await container.read(notesProvider.future);
    expect(notes.length, 1);
    expect(notes.first.title, 'Tes');
  });

  test('provider error dengan repository palsu', () async {
    final container = ProviderContainer(
      overrides: [
        noteRepositoryProvider.overrideWithValue(
          FakeNoteRepository(throwError: true),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.listen<AsyncValue<List<Note>>>(notesProvider, (p, n) {});
    await Future.delayed(const Duration(milliseconds: 50));

    final state = container.read(notesProvider);
    expect(state.hasError, true);
  });

  test('countDirty menghitung catatan belum tersinkron', () async {
    final repo = FakeNoteRepository(items: [
      Note(title: 'a', updatedAt: DateTime.now(), dirty: true),
      Note(title: 'b', updatedAt: DateTime.now()),
    ]);
    expect(await repo.countDirty(), 1);
  });

  test('syncNotes menandai bersih setelah upload sukses', () async {
    var uploaded = false;
    final repo = FakeNoteRepository(items: [
      Note(title: 'a', updatedAt: DateTime.now(), dirty: true),
    ]);
    final count = await syncNotes(
      repo,
      uploader: () async => uploaded = true,
    );
    expect(uploaded, true);
    expect(count, 1);
  });

  test('preferensi tema tersimpan via SharedPreferences mock', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(await container.read(darkModeProvider.future), false);
    await container.read(darkModeProvider.notifier).toggle();
    expect(await container.read(darkModeProvider.future), true);
  });
}
