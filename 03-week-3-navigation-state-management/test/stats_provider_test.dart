import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week3_todo/providers/stats_provider.dart';
import 'package:week3_todo/providers/todo_provider.dart';

/// Pengganti yang selalu gagal, untuk menguji state error.
class _FailStats extends StatsNotifier {
  @override
  Future<Stats> build() async {
    await Future.delayed(const Duration(milliseconds: 10));
    throw Exception('Gagal terhubung ke server');
  }
}

void main() {
  test('statistik sukses menghitung total, selesai, dan sisa', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);

    c.read(todoListProvider.notifier).add('Satu');
    c.read(todoListProvider.notifier).add('Dua');
    c.read(todoListProvider.notifier).add('Tiga');
    c
        .read(todoListProvider.notifier)
        .toggle(c.read(todoListProvider).first.id);

    final stats = await c.read(statsProvider.future);
    expect(stats.total, 3);
    expect(stats.done, 1);
    expect(stats.remaining, 2);
  });

  test('statistik gagal memunculkan AsyncError', () async {
    final c = ProviderContainer(
      overrides: [statsProvider.overrideWith(_FailStats.new)],
    );
    addTearDown(c.dispose);

    // Dengarkan agar provider tetap hidup, tunggu timer selesai.
    c.listen<AsyncValue<Stats>>(statsProvider, (prev, next) {});
    await Future.delayed(const Duration(milliseconds: 50));

    final state = c.read(statsProvider);
    expect(state.hasError, true);
    expect(state, isA<AsyncError<Stats>>());
  });
}
