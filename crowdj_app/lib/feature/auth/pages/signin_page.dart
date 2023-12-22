import '../data/auth_data_source.dart';
import '../data/user_data_source.dart';
import '../providers/authentication_provider.dart';
import '../providers/state/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/user_props.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _wannabeDJ = false; // false = participant, true = DJ
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnamenameController = TextEditingController();
  String _res = "";

  Future<void> _sigUp() async {
    await ref
        .read(authNotifierProvider(AuthDataSource(), UserDataSource()).notifier)
        .signUp(
            _nameController.text,
            _surnamenameController.text,
            _emailController.text,
            _passwordController.text,
            _wannabeDJ ? UserType.dj : UserType.participant);

    var watch =
        ref.watch(authNotifierProvider(AuthDataSource(), UserDataSource()));
    switch (watch) {
      case AuthenticationStateLoading():
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Loading...'),
            ),
          );
        }
        break;
      case AuthenticationStateAuthenticated():
        // watch.userProps.userType contains the user type (e.g. 'PARTICIPANT', 'DJ')
        if (context.mounted) context.go('/homePage');
        break;
      case AuthenticationStateUnauthenticated():
        setState(() {
          _res = watch.message;
        });
        break;
      default:
        break;
    }
  }

  void toggleButtonState() {
    setState(() {
      _wannabeDJ = !_wannabeDJ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 600) {
          return _desktopPage();
        } else {
          return _mobilePage(context);
        }
      },
    );
  }

  Widget _mobilePage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signin Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            errorMessage(),
            subscriptionForm(),
          ],
        ),
      ),
    );
  }

  Widget _desktopPage() {
    return Scaffold(
      appBar: AppBar(title: const Text("Signin Page")),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            errorMessage(),
            subscriptionForm(),
          ],
        ),
      ),
    );
  }

  Widget subscriptionForm() {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'email'),
        ),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'password'),
        ),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'name'),
        ),
        TextField(
          controller: _surnamenameController,
          decoration: const InputDecoration(labelText: 'surname'),
        ),
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: toggleButtonState,
              child: const Text('change'),
            ),
            const SizedBox(width: 20),
            Text(
              _wannabeDJ ? 'DJ' : 'USER',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 30),
        _registerButton(),
      ],
    );
  }

  Widget _registerButton() {
    return ElevatedButton(
      onPressed: _sigUp,
      child: const Text('join crowDJ'),
    );
  }

  Widget errorMessage() {
    if (_res.isEmpty) {
      return const SizedBox();
    } else {
      return Text(
        _res,
        style: const TextStyle(
          color: Colors.red,
        ),
      );
    }
  }
}
