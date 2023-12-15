import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_data_source.dart';
import '../data/user_data_source.dart';
import '../providers/authentication_provider.dart';
import '../providers/state/authentication_state.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final provider = authNotifierProvider(AuthDataSource(), UserDataSource());

  Future<void> _login() async {
    await ref
        .read(provider.notifier)
        .signIn(_usernameController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(provider);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (watch is AuthenticationStateUnauthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(watch.message),
            ),
          );
        }
        if (constraints.maxWidth > 600) {
          return _desktopPage();
        } else {
          return _mobilePage();
        }
      },
    );
  }

  Widget _mobilePage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: loginForm(),
      ),
    );
  }

  Widget _desktopPage() {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: loginForm(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Image.asset('lib/assets/crow.jpg'),
          )
        ],
      ),
    );
  }

  Widget loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'email'),
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'password'),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _login,
          child: const Text('Login'),
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () => context.replace('/signinPage'),
          child: const Text('register'),
        ),
      ],
    );
  }
}
