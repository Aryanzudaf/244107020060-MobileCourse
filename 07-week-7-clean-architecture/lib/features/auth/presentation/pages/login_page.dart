import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failures.dart';
import '../providers/auth_providers.dart';

/// `/login`: validasi lokal + error dari use case (dalam bentuk [Failure]).
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Demo screenshot error: isi buruk + submit otomatis.
    if (Uri.base.queryParameters['autofail'] == '1') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _email.text = 'salah';
        _password.text = '123';
        ref.read(authStateProvider.notifier).login('salah', '123');
      });
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Masuk Kampus')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              children: [
                const Icon(Icons.school_outlined, size: 64),
                const SizedBox(height: 12),
                const Text('Aryan Zuda F • TI-3D'),
                const SizedBox(height: 16),
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    labelText: 'Email kampus',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Kata sandi (min. 6)',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 16),
                if (authAsync case AsyncError(:final error))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      errorMessage(error),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                FilledButton(
                  onPressed: authAsync.isLoading
                      ? null
                      : () => ref.read(authStateProvider.notifier).login(
                            _email.text.trim(),
                            _password.text,
                          ),
                  child: const Text('Masuk'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
