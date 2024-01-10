import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_data_source.dart';
import '../data/user_data_source.dart';
import '../providers/authentication_provider.dart';
import '../providers/state/authentication_state.dart';
import '../widgets/form_skeleton.dart';
import '../widgets/responsive_card_with_image.dart';
import '../widgets/utils/custom_form_styles.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 212, 232, 245),
        ),
        alignment: Alignment.center,
        child: ResponsiveCardWithImage(
            child: FormSkeleton(
                title: ("Login to discover the best parties!"),
                form: loginForm())),
      ),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            autofocus: true,
            controller: _usernameController,
            decoration: customInputDecorator(
              labelText: 'email',
              hintText: 'Enter your email',
              icon: Icons.email,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                (value!.isEmpty || !value.contains('@') || !value.contains('.'))
                    ? 'Enter a valid email'
                    : null,
            onFieldSubmitted: (value) => _login(),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: customInputDecorator(
              labelText: 'password',
              hintText: 'Enter your password',
              icon: Icons.lock,
            ),
            validator: (value) =>
                value!.isEmpty ? 'Enter a valid password' : null,
            onFieldSubmitted: (value) => _login(),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async => _login(),
            child: const Text('Let me in!'),
          ),
          const SizedBox(height: 20.0),
          TextButton(
              onPressed: () => context.go('/signin'),
              child: const Text("Don't have an account? Join us!")),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(provider.notifier)
          .signIn(_usernameController.text, _passwordController.text);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
