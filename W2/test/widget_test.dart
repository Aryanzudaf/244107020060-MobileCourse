import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_dashboard/main.dart';

void main() {
  group('Academic Overview Dashboard Responsive & Interaction Tests', () {
    testWidgets('Dashboard satu kolom di layar sempit (< 700px)', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const AcademicDashboardApp());
      await tester.pumpAndSettle();

      // Verifikasi kartu ter-render
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsWidgets);

      // Pada layar 400px, kartu mengisi lebar 1 kolom (lebar ~368px, kurang dari 700px)
      final firstCardWidth = tester.getSize(cardFinder.first).width;
      expect(firstCardWidth, lessThan(700));
      expect(firstCardWidth, greaterThan(300));

      // Verifikasi badge status indikator 1 kolom
      expect(find.text('Layar Sempit (1 Kolom)'), findsOneWidget);
    });

    testWidgets('Dashboard dua kolom di layar lebar (>= 700px)', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const AcademicDashboardApp());
      await tester.pumpAndSettle();

      final cardFinder = find.byType(Card);
      expect(cardFinder, findsWidgets);

      // Pada layar lebar 1200px (grid 2 kolom), masing-masing kartu memiliki lebar ~526px
      final firstCardWidth = tester.getSize(cardFinder.first).width;
      expect(firstCardWidth, greaterThan(500));
      expect(firstCardWidth, lessThan(600));

      // Verifikasi badge status indikator 2 kolom
      expect(find.text('Layar Lebar (2 Kolom)'), findsOneWidget);
    });

    testWidgets('Header profil menampilkan data mahasiswa dengan tepat', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const AcademicDashboardApp());
      await tester.pumpAndSettle();

      expect(find.text('Aryan Zuda F'), findsOneWidget);
      expect(find.text('NIM: 244107020060'), findsOneWidget);
      expect(find.text('Reguler Aktif'), findsOneWidget);
      expect(find.text('IPK Kumulatif'), findsOneWidget);
      expect(find.text('3.88'), findsOneWidget);
      expect(find.text('Status Akademik'), findsOneWidget);
      expect(find.text('Aktif'), findsOneWidget);
    });

    testWidgets('Toggle tema dengan CupertinoSwitch mengubah ThemeMode', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const AcademicDashboardApp());
      await tester.pumpAndSettle();

      // Cek awal adalah light mode (icon light_mode)
      expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);

      // Tekan CupertinoSwitch
      final switchFinder = find.byType(CupertinoSwitch);
      expect(switchFinder, findsOneWidget);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Sekarang beralih ke dark mode (icon dark_mode)
      expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
    });
  });
}
