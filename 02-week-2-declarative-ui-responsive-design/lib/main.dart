import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:responsive_dashboard/profile_warmup.dart';

/// Konstanta breakpoint responsif untuk membedakan layar sempit dan lebar
const double kWideBreakpoint = 700.0;

void main() => runApp(const AcademicDashboardApp());

/// Aplikasi utama dengan manajemen state tema (Light/Dark Mode)
class AcademicDashboardApp extends StatefulWidget {
  const AcademicDashboardApp({this.initialDark, super.key});

  final bool? initialDark;

  @override
  State<AcademicDashboardApp> createState() => _AcademicDashboardAppState();
}

class _AcademicDashboardAppState extends State<AcademicDashboardApp> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = widget.initialDark ?? (Uri.base.queryParameters['theme'] == 'dark');
  }

  void toggleTheme(bool value) {
    setState(() {
      isDark = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final showWarmup = Uri.base.queryParameters['page'] == 'warmup';
    return MaterialApp(
      title: 'Academic Overview Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
        cardTheme: CardThemeData(
          elevation: 2,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.indigo.shade50, width: 1),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF12141C),
        cardTheme: CardThemeData(
          elevation: 1,
          surfaceTintColor: Colors.transparent,
          color: const Color(0xFF1B1E2B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.indigo.shade900.withValues(alpha: 0.4), width: 1),
          ),
        ),
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: showWarmup
          ? const Scaffold(body: Center(child: ProfileCard()))
          : AcademicOverviewPage(
              isDark: isDark,
              onDarkChanged: toggleTheme,
            ),
    );
  }
}

/// Halaman Academic Overview Responsif
class AcademicOverviewPage extends StatelessWidget {
  const AcademicOverviewPage({
    required this.isDark,
    required this.onDarkChanged,
    super.key,
  });

  final bool isDark;
  final ValueChanged<bool> onDarkChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Academic Overview',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          Semantics(
            label: isDark ? 'Beralih ke mode terang' : 'Beralih ke mode gelap',
            button: true,
            toggled: isDark,
            child: Row(
              children: [
                Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: colorScheme.primary,
                  size: 22,
                ),
                const SizedBox(width: 6),
                CupertinoSwitch(
                  activeTrackColor: colorScheme.primary,
                  value: isDark,
                  onChanged: onDarkChanged,
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= kWideBreakpoint;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Profil Mahasiswa
                    const ProfileHeaderSection(),
                    const SizedBox(height: 24),

                    // Label Subtitle & Status Ringkasan
                    Row(
                      children: [
                        Icon(
                          Icons.insights_rounded,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Ringkasan Perkuliahan',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isWide ? 'Layar Lebar (2 Kolom)' : 'Layar Sempit (1 Kolom)',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Grid Kartu Informasi Responsif
                    GridView.count(
                      crossAxisCount: isWide ? 2 : 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isWide ? 2.8 : 2.5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        AcademicInfoCard(
                          title: 'IPK Kumulatif',
                          value: '3.88',
                          subtitle: 'Predikat Sangat Memuaskan',
                          icon: Icons.school_rounded,
                          accentColor: Colors.blueAccent,
                        ),
                        AcademicInfoCard(
                          title: 'Total SKS Ditempuh',
                          value: '92 / 144',
                          subtitle: 'Progres Kelulusan 63.8%',
                          icon: Icons.auto_stories_rounded,
                          accentColor: Colors.purpleAccent,
                        ),
                        AcademicInfoCard(
                          title: 'Tingkat Kehadiran',
                          value: '95.5%',
                          subtitle: 'Bebas Jam Kompensasi (Alpha: 0)',
                          icon: Icons.fact_check_rounded,
                          accentColor: Colors.teal,
                        ),
                        AcademicInfoCard(
                          title: 'Status Akademik',
                          value: 'Aktif',
                          subtitle: 'KRS Semester Ganjil Terverifikasi',
                          icon: Icons.verified_user_rounded,
                          accentColor: Colors.green,
                        ),
                        AcademicInfoCard(
                          title: 'Tugas & Proyek',
                          value: '18 / 20',
                          subtitle: '2 Tugas Menunggu Review Dosen',
                          icon: Icons.task_alt_rounded,
                          accentColor: Colors.orangeAccent,
                        ),
                        AcademicInfoCard(
                          title: 'Beban SKS Semester 5',
                          value: '20 SKS',
                          subtitle: '8 Mata Kuliah Terdaftar',
                          icon: Icons.calendar_today_rounded,
                          accentColor: Colors.indigoAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Header Profil Mahasiswa yang menggabungkan Container, Row, Column, dan Expanded
class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: 'Informasi Profil Mahasiswa Aryan Zuda F NIM 244107020060',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar Profil
            CircleAvatar(
              radius: 36,
              backgroundColor: colorScheme.primary,
              child: Text(
                'AZ',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 18),

            // Informasi Mahasiswa menggunakan Expanded dan Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Aryan Zuda F',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Text(
                          'Reguler Aktif',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIM: 244107020060',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'D4 Teknik Informatika • TI-3D • SMT-5',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget Reusable untuk Kartu Informasi Akademik (Refactoring Challenge)
class AcademicInfoCard extends StatelessWidget {
  const AcademicInfoCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.accentColor,
    super.key,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = accentColor ?? colorScheme.primary;

    return Semantics(
      label: 'Kartu $title bernilai $value, keterangan $subtitle',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),

              // Title and Subtitle in Column
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Value Text
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
