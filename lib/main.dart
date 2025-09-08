import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:web_google_docs/providers/auth_provider.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleSignInPlatform.instance.init(
    const InitParameters(
      clientId:
          '57220874610-aqu17qkr4aki8teh3fl5gvjt8cf78o06.apps.googleusercontent.com',
    ),
  );
  await dotenv.load();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}
