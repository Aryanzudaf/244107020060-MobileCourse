import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../routes.dart';

/// `/`: token terpotong, izin, topik + banner foreground (klik -> deep link).
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(pushUiProvider.notifier).setup());
  }

  @override
  Widget build(BuildContext context) {
    final push = ref.watch(pushUiProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengumuman Kampus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Keluar',
            onPressed: () =>
                ref.read(authStateProvider.notifier).logout(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (push.banner != null)
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: Text(push.banner!),
                subtitle: const Text('Ketuk untuk membuka pengumuman.'),
                onTap: () {
                  ref.read(pushUiProvider.notifier).dismissBanner();
                  context.go(AppRoutes.announcement('3'));
                },
              ),
            ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.key_outlined),
              title: const Text('Token perangkat'),
              subtitle: Text(push.tokenPreview),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.verified_outlined),
              title: const Text('Izin notifikasi'),
              subtitle: Text(push.permission),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.topic_outlined),
              title: const Text('Topik'),
              subtitle: Text(push.topic),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => context.go(AppRoutes.announcement('3')),
            child: const Text('Buka pengumuman 3'),
          ),
        ],
      ),
    );
  }
}
