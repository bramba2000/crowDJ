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
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 212, 232, 245),
        ),
        alignment: Alignment.center,
        child: responsiveSingleFormLayout(loginForm()),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            autofocus: true,
            focusNode: _focusNode,
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
            onFieldSubmitted: (value) => _login(),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'password'),
            validator: (value) =>
                value!.isEmpty ? 'Enter a valid password' : null,
            onFieldSubmitted: (value) => _login(),
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

  Widget responsiveSingleFormLayout(Widget formWidget) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double breackPointWidth = 700;
        const double breackPointHeight = 700;

        if (constraints.maxWidth > breackPointWidth) {
          return Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                ),
              ],
              color: Colors.white,
            ),
            constraints: const BoxConstraints(
              maxHeight: breackPointHeight,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: formWidget,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Image.asset(
                    'lib/assets/crowd_mobile_background.jpeg',
                    alignment: Alignment.centerRight,
                  ),
                )
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: formWidget,
          );
        }
      },
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(provider.notifier)
          .signIn(_usernameController.text, _passwordController.text);
    } else {
      _focusNode.requestFocus();
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
    _focusNode.dispose();
    super.dispose();
  }
}
