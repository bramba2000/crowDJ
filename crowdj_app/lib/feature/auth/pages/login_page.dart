import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_data_source.dart';
import '../data/user_data_source.dart';
import '../providers/authentication_provider.dart';
import '../providers/state/authentication_state.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final provider = authNotifierProvider(AuthDataSource(), UserDataSource());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(provider.notifier)
          .signIn(_usernameController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > 600) {
              return _desktopPage();
            } else {
              return _mobilePage();
            }
          },
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget _mobilePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: loginForm(),
    );
  }

  Widget _desktopPage() {
    return Row(
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
    );
  }

  Widget loginForm() {
    var watch = ref.watch(provider);
    if (watch is AuthenticationStateUnauthenticated) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _showSnackBar(watch.exception is FirebaseAuthException
            ? (watch.exception as FirebaseAuthException).message!
            : 'Something went wrong');
      });
    }
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'email',
              errorText: '',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                (value!.isEmpty || !value.contains('@') || !value.contains('.'))
                    ? 'Enter a valid email'
                    : null,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'password'),
            keyboardType: TextInputType.visiblePassword,
            validator: (value) =>
                value!.isEmpty ? 'Enter a valid password' : null,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _login,
            child: const Text('Login'),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () => context.replace('/signin'),
            child: const Text('register'),
          ),
        ],
      ),
    );
  }
}
