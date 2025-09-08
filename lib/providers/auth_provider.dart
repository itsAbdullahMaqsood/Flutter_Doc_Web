import 'package:go_router/go_router.dart';
import 'package:web_google_docs/models/user_model.dart';
import 'package:web_google_docs/repository/auth_repository.dart';
import 'package:web_google_docs/screens/home_screen.dart';
import 'package:web_google_docs/screens/login_screen.dart';
import 'package:web_google_docs/screens/splash_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final googleAuthProvider = StateProvider<GoogleSignInUserData?>((ref) => null);

final googleErrorProvider = StateProvider<String?>((ref) => null);

final googleSignInProvider = StateProvider<GoogleSignIn>((ref) {
  return GoogleSignIn.instance;
});

final googleWebSignInPlatformProvider = StateProvider<GoogleSignInPlatform>((
  ref,
) {
  return GoogleSignInPlatform.instance;
});

final userServiceProvider = Provider<UserService>((ref) => UserService());

final routerProvider = Provider<GoRouter>((ref) {
  final initState = ref.watch(initUserProvider);
  final user = ref.watch(userProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    ],
    redirect: (context, state) {
      // still loading user data
      if (initState.isLoading) {
        if (state.matchedLocation != '/splash') {
          return '/splash'; // only redirect if not already on splash
        }
        return null; // stay on splash
      }

      // finished loading, but no user → login
      if (user == null) {
        if (state.matchedLocation != '/login') {
          return '/login';
        }
        return null; // stay on login
      }

      // finished loading, user exists → home
      if (state.matchedLocation != '/home') {
        return '/home';
      }
      return null; // stay on home
    },
  );
});

final initUserProvider = FutureProvider<void>((ref) async {
  await _fetchAndSetUserDataFromRef(ref);
});

Future<void> _fetchAndSetUserDataFromRef(ref) async {
  final service = ref.read(userServiceProvider);

  try {
    final user = await service.getUserData();
    if (user != null) {
      ref.read(userProvider.notifier).state = user;
    }
  } catch (e, st) {
    print("fetchAndSetUserData error: $e\n$st");
    // Optional: log or set an error state
  }
}

Future<void> fetchAndSetUserData(WidgetRef widgetRef) =>
    _fetchAndSetUserDataFromRef(widgetRef);
