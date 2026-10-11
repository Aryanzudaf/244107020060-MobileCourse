import 'package:flutter/material.dart';

void main() => runApp(const ProfileApp());

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: ProfileCard()),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.indigo,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Nama Mahasiswa',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Aryan Zuda F',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          const Row(
            children: [
              Expanded(
                child: Text('NIM', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              Text('244107020060'),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Expanded(
                child: Text('Kelas', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              Text('TI-3D / D4 TI'),
            ],
          ),
          const SizedBox(height: 6),
          // Eksperimen 3: Menambahkan baris Email menggunakan pola Row + Expanded
          const Row(
            children: [
              Expanded(
                child: Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              Text('aryanzf1@gmail.com'),
            ],
          ),
        ],
      ),
    );
  }
}
