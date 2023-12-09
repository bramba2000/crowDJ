import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:crowdj/pages/LoginPage.dart';
import 'package:crowdj/pages/SigninPage.dart';
import 'package:crowdj/pages/app/HomePage.dart';

void main() => runApp( MainApp());


class MainApp extends StatelessWidget {

  MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: "title",
    );
  }

  // GoRouter configuration
  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'signinPage',
            builder: (context, state) =>const SigninPage(),
          ), 
          GoRoute(
            path: 'homePage',
            builder: (context, state) =>const HomePage()
          )
        ]
      ), 
    ],
  );
}
