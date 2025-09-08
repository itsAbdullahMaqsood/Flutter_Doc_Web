import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_google_docs/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      body: Center(
        child: Text(
          user == null
              ? "Hi, nothing to show here"
              : "${user.uid}\n${user.email}",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
