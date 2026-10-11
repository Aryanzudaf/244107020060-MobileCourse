import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';

/// Pengaturan: toggle tema + info terakhir dibuka (SharedPreferences).
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkAsync = ref.watch(darkModeProvider);
    final openedAsync = ref.watch(lastOpenedProvider);
    final offline = ref.watch(forceOfflineProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Mode gelap'),
            subtitle: const Text('Disimpan di SharedPreferences'),
            value: darkAsync.value ?? false,
            onChanged: (_) => ref.read(darkModeProvider.notifier).toggle(),
          ),
          SwitchListTile(
            title: const Text('Simulasi offline'),
            subtitle: const Text('forceOffline deterministik untuk demo'),
            value: offline,
            onChanged: (v) =>
                ref.read(forceOfflineProvider.notifier).set(v),
          ),
          ListTile(
            leading: const Icon(Icons.history_outlined),
            title: const Text('Terakhir dibuka'),
            subtitle: openedAsync.when(
              loading: () => const Text('...'),
              error: (e, _) => Text('Gagal: $e'),
              data: (v) => Text(v ?? '-'),
            ),
          ),
          const ListTile(
            leading: CircleAvatar(child: Text('AZ')),
            title: Text('Aryan Zuda F'),
            subtitle: Text('244107020060 • TI-3D'),
          ),
        ],
      ),
    );
  }
}
