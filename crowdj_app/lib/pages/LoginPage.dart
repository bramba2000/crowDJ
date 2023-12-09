import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _userType = '';

  void _login() { //by now is bruteforce

    // Check user credentials and set user type
    String enteredUsername = _usernameController.text;
    String enteredPassword = _passwordController.text;

    // For simplicity, hardcoding credentials. In a real app, you would check against a database or an authentication service.
    if (enteredUsername == 'admin' && enteredPassword == 'admin123') {
      _userType = 'Admin';
    } else if (enteredUsername == 'user' && enteredPassword == 'user123') {
      _userType = 'Regular User';
    } else {
      _userType = '';
    }

    // Navigate to the appropriate page based on the user type
    if (_userType.isNotEmpty) {
      print("login good practice");
      //context.goNamed('/HomePage’),

    } else {
      // Show an error message or handle invalid credentials
      print('Invalid credentials, try again');
    }

    context.go('/homePage');

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'email'),
            ),
            SizedBox(height: 16.0),
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
              onPressed: () => context.go('/signinPage'),
              child: Text('register'),
            ),
          ],
        ),
      ),
    );
  }
}