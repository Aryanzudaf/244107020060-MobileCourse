import 'package:flutter/material.dart';

/// `/pengumuman/:id`: tujuan deep link klik notifikasi.
class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pengumuman $id')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jadwal kuliah berubah',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text(
              'Kelas Pemrograman Mobile TI-3D pindah ke Ruang A2 jam 13.00. '
              'Halaman ini dibuka lewat deep link dari notifikasi.',
            ),
          ],
        ),
      ),
    );
  }
}
