import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:web_google_docs/models/user_model.dart';
import 'package:web_google_docs/providers/auth_provider.dart';
import 'package:web_google_docs/repository/local_storage_repository.dart';
import 'package:web_google_docs/screens/home_screen.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/web_only.dart';
import '../src/button_configuration_column.dart';

class WebButtonGoogleSignIn extends ConsumerStatefulWidget {
  const WebButtonGoogleSignIn({super.key});

  @override
  ConsumerState<WebButtonGoogleSignIn> createState() =>
      _WebButtonGoogleSignInState();
}

class _WebButtonGoogleSignInState extends ConsumerState<WebButtonGoogleSignIn> {
  GoogleSignInUserData? user; // sign-in information?
  GSIButtonConfiguration? _buttonConfiguration; // button configuration

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showID();
  }

  void _handleSignOut() {
    final GoogleSignInPlatform platform = ref.read(
      googleWebSignInPlatformProvider,
    );
    platform.signOut(const SignOutParams());
  }

  void _handleNewWebButtonConfiguration(GSIButtonConfiguration newConfig) {
    setState(() {
      _buttonConfiguration = newConfig;
    });
  }

  void showID() {
    final navigator = Navigator.of(context);
    final GoogleSignInPlatform platform = ref.read(
      googleWebSignInPlatformProvider,
    );
    final client = Client();
    final localStorageRepo = LocalStorageRepository();
    platform.authenticationEvents?.listen((
      AuthenticationEvent authEvent,
    ) async {
      switch (authEvent) {
        case AuthenticationEventSignIn():
          user = authEvent.user;
          print("${user!.email} + ${user!.id}");
          ref.read(googleAuthProvider.notifier).state = user;
          final auth = authEvent.authenticationTokens;
          await fetchAndSetUserData(ref);
          final userAcc = UserModel(
            email: user!.email,
            name: user!.displayName!,
            profilePic: user!.photoUrl!,
            token: '',
            uid: '',
          );
          var res = await client.post(
            Uri.parse('${dotenv.env['API_HOST']}/api/signup'),
            body: jsonEncode(userAcc.toJson()),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
          );
          switch (res.statusCode) {
            case 200:
              final newUser = userAcc.copyWith(
                uid: jsonDecode(res.body)['user']['_id'],
                token: jsonDecode(res.body)['token'],
              );
              localStorageRepo.setToken(newUser.token!);
              ref.read(userProvider.notifier).update((state) => newUser);
          }
          navigator.push(MaterialPageRoute(builder: (_) => HomeScreen()));
        case AuthenticationEventSignOut():
        case AuthenticationEventException():
          setState(() {
            user = null;
          });
      }
    });
  }

  Widget _buildBody() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (user == null)
                renderButton(configuration: _buttonConfiguration),
              if (user != null) ...<Widget>[
                Text('Hello, ${user!.displayName}!'),
                ElevatedButton(
                  onPressed: _handleSignOut,
                  child: const Text('SIGN OUT'),
                ),
              ],
            ],
          ),
        ),
        renderWebButtonConfiguration(
          _buttonConfiguration,
          onChange: user == null ? _handleNewWebButtonConfiguration : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in with Google button Tester')),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(),
      ),
    );
  }
}
