
import 'package:crowdj/feature/auth/data/auth_data_source.dart';
import 'package:crowdj/feature/auth/providers/authentication_provider.dart';
import 'package:crowdj/feature/auth/providers/state/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends ConsumerState<LoginPage> {

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    //by now is bruteforce

    // Check user credentials and set user type
    String enteredUsername = _usernameController.text;
    String enteredPassword = _passwordController.text;

    // Logic with the user credentials
    final notifier = ref.read(authNotifierProvider(AuthDataSource()).notifier);

    await notifier.signIn(enteredUsername, enteredPassword);

    // Navigate to the appropriate page based on the user type
    if (notifier.state case AuthenticationStateAuthenticated()) {
      //print("login good practice");
      context.go(
        '/homePage',
      );
    } else {
      context.go(
        '/homePage',
      );
      // Show an error message or handle invalid credentials
      print('Invalid credentials, try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
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

  Widget _desktopPage(){
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child:
            Padding(
              padding: const EdgeInsets.all(25),
              child:
                loginForm(),  
            ),
          ),
          Expanded(
            flex:3 ,
            child: Image.asset('lib/assets/crow.jpg'),)
        ],
      ),
    );
  }

  Widget loginForm(){
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'email'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => context.replace('/signinPage'),
              child: Text('register'),
            ),
          ],
        );
  }
}
