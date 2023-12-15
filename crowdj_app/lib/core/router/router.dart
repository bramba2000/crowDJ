import 'package:crowdj/feature/auth/data/auth_data_source.dart';
import 'package:crowdj/feature/auth/data/user_data_source.dart';
import 'package:crowdj/feature/auth/providers/authentication_provider.dart';
import 'package:crowdj/pages/app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../feature/auth/providers/state/authentication_state.dart';
import '../../feature/auth/pages/LoginPage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

final _key = GlobalKey<NavigatorState>(debugLabel: 'routerKey');

@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(
      authNotifierProvider(defaultAuthDataSource, defaultUserDataSource));
  final isAuthenticated = authState is AuthenticationStateAuthenticated;

  return GoRouter(
    navigatorKey: _key,
    initialLocation: isAuthenticated ? '/' : '/login',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const MaterialPage(child: HomePage()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => const MaterialPage(child: LoginPage()),
      ),
    ],
    redirect: (context, state) {
      if (isAuthenticated) {
        return '/';
      } else {
        return '/login';
      }
    },
  );
}
