import 'package:crowdj/firebase_options.dart';
import 'package:crowdj/pages/app/EventPage.dart';
import 'package:crowdj/utils/Event.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:crowdj/pages/LoginPage.dart';
import 'package:crowdj/pages/SigninPage.dart';
import 'package:crowdj/pages/app/HomePage.dart';
import 'package:crowdj/pages/app/djPages/CreateNewEventPage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ProviderScope(child: MainApp()));
}

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
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
        routes: [
          GoRoute(
            path: 'signinPage',
            builder: (context, state) => const SigninPage(),

          ),
          GoRoute(
            path: 'homePage',
            builder: (context, state) => const HomePage(),
            routes: [
              GoRoute(
                path: "EventPage",
                builder: (context, state){
                  Event args = state.extra as Event; // 👈 casting is important
                  return EventPage(args: args);
                }
              ),
              GoRoute(
                path: "CreateNewEventPage",
                builder: (context, state) => CreateNeweventPage(),
                
              ),
            ]   
          ),
        ]
      ),
    ],
  );
}
