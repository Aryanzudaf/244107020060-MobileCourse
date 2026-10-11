import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week5_offline_notes/data/local/note.dart';
import 'package:week5_offline_notes/widgets/note_tile.dart';

void main() {
  testWidgets('NoteTile menampilkan badge belum tersinkron', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteTile(
            note: Note(
              title: 'Belanja',
              updatedAt: DateTime.now(),
              dirty: true,
            ),
            onDelete: () {},
          ),
        ),
      ),
    );

    expect(find.text('Belanja'), findsOneWidget);
    expect(find.text('Belum tersinkron'), findsOneWidget);
  });

  testWidgets('NoteTile tidak menampilkan badge saat sinkron', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteTile(
            note: Note(title: 'Lunas', updatedAt: DateTime.now()),
            onDelete: () {},
          ),
        ),
      ),
    );

    expect(find.text('Lunas'), findsOneWidget);
    expect(find.text('Belum tersinkron'), findsNothing);
  });
}
