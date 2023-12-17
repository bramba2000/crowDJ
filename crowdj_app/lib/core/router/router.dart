import 'package:crowdj/feature/auth/data/auth_data_source.dart';
import 'package:crowdj/feature/auth/data/user_data_source.dart';
import 'package:crowdj/feature/auth/pages/SigninPage.dart';
import 'package:crowdj/feature/auth/pages/app/djPages/CreateNewEventPage.dart';
import 'package:crowdj/feature/auth/providers/authentication_provider.dart';
import 'package:crowdj/feature/auth/pages/app/home_page.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import '../../feature/auth/providers/state/authentication_state.dart';
import '../../feature/auth/pages/LoginPage.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

final _key = GlobalKey<NavigatorState>(debugLabel: 'routerKey');

@riverpod
GoRouter router(RouterRef ref) {

  bool inLoginPage = false;
  final authState = ref.watch(
      authNotifierProvider(defaultAuthDataSource, defaultUserDataSource));
  final isAuthenticated = authState is AuthenticationStateAuthenticated;

  return GoRouter(
    navigatorKey: _key,
    initialLocation: isAuthenticated ? '/' : '/login',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state){ 
          print("building HomePage");
          return const MaterialPage(
            child: HomePage()
          );
        },
        routes: [
          GoRoute(
            path: "createNewEventPage",
            pageBuilder: (context, state) { 
              print("building CreateNeweventPage");
              return MaterialPage(
                child: CreateNeweventPage(),
              );
            }
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          inLoginPage=!inLoginPage;
          return const MaterialPage(
            child: LoginPage(),
          );
        },
      ),
      GoRoute(
        path: '/signin',
        pageBuilder: (context, state) => const MaterialPage(
          child: SigninPage(),
        ),
      ),
    ],
    redirect: (context, state) {
      if (isAuthenticated) {
        return '/';
      } else {
        return inLoginPage? '/signin' : '/login' ;
      }
    },
  );
}
