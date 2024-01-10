import '../data/auth_data_source.dart';
import '../data/user_data_source.dart';
import '../providers/authentication_provider.dart';
import '../providers/state/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/user_props.dart';
import '../widgets/form_skeleton.dart';
import '../widgets/responsive_card_with_image.dart';
import '../widgets/utils/custom_form_styles.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnamenameController = TextEditingController();
  bool _wannabeDJ = false; // false = participant, true = DJ
  String _res = "";

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
                title: ("Join us to discover the best parties!"),
                form: subscriptionForm())),
      ),
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
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: customInputDecorator(
              labelText: 'email',
              hintText: 'email',
              icon: Icons.email,
            ),
          ),
          formFieldSpace,
          TextField(
            controller: _passwordController,
            decoration: customInputDecorator(
              labelText: 'password',
              hintText: 'password',
              icon: Icons.lock,
            ),
          ),
          formFieldSpace,
          TextField(
            controller: _nameController,
            decoration: customInputDecorator(
              labelText: 'name',
              hintText: 'name',
              icon: Icons.person,
            ),
          ),
          formFieldSpace,
          TextField(
            controller: _surnamenameController,
            decoration: customInputDecorator(
              labelText: 'surname',
              hintText: 'surname',
              icon: Icons.person,
            ),
          ),
          formFieldSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Are you a DJ?"),
              const SizedBox(width: 10),
              Checkbox(value: _wannabeDJ, onChanged: (_) => toggleButtonState())
            ],
          ),
          formFieldSpace,
          _registerButton(),
          formFieldSpace,
          TextButton(
              onPressed: () => context.replace('/login'),
              child: const Text("Already have an account? Login!")),
        ],
      ),
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
}
