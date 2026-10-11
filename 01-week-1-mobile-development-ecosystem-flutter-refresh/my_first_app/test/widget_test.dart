import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/main.dart';
import 'package:my_first_app/latihan_mandiri.dart';

void main() {
  group('Latihan mandiri Dart', () {
    test('hitungLuasPersegiPanjang menghitung dengan benar', () {
      expect(hitungLuasPersegiPanjang(12.5, 4.2), closeTo(52.5, 0.001));
      expect(hitungLuasPersegiPanjang(7.0, 3.0), 21.0);
      expect(hitungLuasPersegiPanjang(0, 9.5), 0);
    });

    test('Profil menampilkan fallback saat email kosong', () {
      const kosong = Profil(nama: 'Aryan Zuda F', nim: '244107020060');
      expect(kosong.ringkasan(), contains('belum diisi'));

      const spasi = Profil(
        nama: 'Aryan Zuda F',
        nim: '244107020060',
        email: '   ',
      );
      expect(spasi.ringkasan(), contains('belum diisi'));

      const ada = Profil(
        nama: 'Aryan Zuda F',
        nim: '244107020060',
        email: 'aryanzf1@gmail.com',
      );
      expect(ada.ringkasan(), contains('aryanzf1@gmail.com'));
    });
  });

  group('StudentCardApp widget', () {
    testWidgets('menampilkan identitas Aryan Zuda F', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const StudentCardApp());
      await tester.pumpAndSettle();

      expect(find.text('Aryan Zuda F'), findsOneWidget);
      expect(find.text('244107020060'), findsOneWidget);
      expect(find.text('TI-3D'), findsOneWidget);
      expect(find.text('aryanzf1@gmail.com'), findsOneWidget);
      expect(find.text('Kartu Mahasiswa • W1'), findsOneWidget);
    });
  });
}
