import 'package:flutter/material.dart';

import '../data/local/note.dart';

/// Baris catatan + badge "belum tersinkron" bila `dirty == true`.
class NoteTile extends StatelessWidget {
  const NoteTile({super.key, required this.note, required this.onDelete});

  final Note note;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.note_outlined),
      title: Text(note.title),
      subtitle: Text(
        note.body,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (note.dirty)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Belum tersinkron',
                style: TextStyle(fontSize: 11, color: Colors.brown),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
