import 'package:crowdj/feature/auth/data/auth_data_source.dart';
import 'package:crowdj/feature/auth/providers/authentication_provider.dart';
import 'package:crowdj/feature/auth/providers/state/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _userType = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnamenameController = TextEditingController();
  String _res = "";

  Future<String> _sigin(String mail, String pswd) async {
    final data = AuthDataSource();
    final authProvider = ref.watch(authNotifierProvider(data));
    final notifier = ref.read(authNotifierProvider(data).notifier);
    String res = "";

    await notifier.signUp(mail, pswd);

    switch (authProvider) {
      case AuthenticationStateAuthenticated():
        res = "";
        break;

      case AuthenticationStateUnauthenticated():
        res = authProvider.message;
        break;

      default:
        res = " generic error";
    }
    return res;
  }

  void toggleButtonState() {
    setState(() {
      _userType = !_userType;
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
              _userType ? 'DJ' : 'USER',
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
      onPressed: () async {
        _res = await _sigin(_emailController.text, _passwordController.text);

        if (_res.isEmpty) {
          context.go('/homePage');
        } else {
          context.go('/homePage');
          //setState(() {});  <<<------- un-comment it 
        }
      },
      child: const Text('join crowDJ'),
    );
  }

  Widget errorMessage() {
    if (_res.isEmpty)
      return SizedBox();
    else {
      return Text(
        _res,
        style: const TextStyle(
          color: Colors.red,
        ),
      );
    }
  }
}
