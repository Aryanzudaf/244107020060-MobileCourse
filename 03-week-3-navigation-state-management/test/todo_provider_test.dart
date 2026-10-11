import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week3_todo/providers/todo_provider.dart';

ProviderContainer _container() {
  final c = ProviderContainer();
  addTearDown(c.dispose);
  return c;
}

void main() {
  test('add, toggle, dan remove menghasilkan state baru', () {
    final c = _container();
    final notifier = c.read(todoListProvider.notifier);

    notifier.add('Belajar GoRouter');
    notifier.add('Belajar Riverpod');
    expect(c.read(todoListProvider).length, 2);

    final before = c.read(todoListProvider);
    final id = before.first.id;
    notifier.toggle(id);
    // State lama tidak berubah (immutable), state baru berbeda objek.
    expect(before.first.done, false);
    expect(c.read(todoListProvider).first.done, true);
    expect(identical(before, c.read(todoListProvider)), false);

    notifier.remove(id);
    expect(c.read(todoListProvider).length, 1);
  });

  test('filteredTodosProvider mengikuti filter', () {
    final c = _container();
    final notifier = c.read(todoListProvider.notifier);
    notifier.add('Satu');
    notifier.add('Dua');
    notifier.toggle(c.read(todoListProvider).first.id);

    c.read(todoFilterProvider.notifier).set(TodoFilter.aktif);
    expect(c.read(filteredTodosProvider).length, 1);
    expect(c.read(filteredTodosProvider).first.title, 'Dua');

    c.read(todoFilterProvider.notifier).set(TodoFilter.selesai);
    expect(c.read(filteredTodosProvider).length, 1);
    expect(c.read(filteredTodosProvider).first.title, 'Satu');

    c.read(todoFilterProvider.notifier).set(TodoFilter.semua);
    expect(c.read(filteredTodosProvider).length, 2);
  });
}
