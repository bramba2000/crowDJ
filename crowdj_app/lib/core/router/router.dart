import '../../feature/auth/data/auth_data_source.dart';
import '../../feature/auth/data/user_data_source.dart';
import '../../feature/auth/pages/signin_page.dart';
import '../../feature/auth/pages/app/EventPage.dart';
import '../../feature/auth/pages/app/djPages/CreateNewEventPage.dart';
import '../../feature/auth/providers/authentication_provider.dart';
import '../../feature/auth/pages/app/home_page.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import '../../feature/auth/providers/state/authentication_state.dart';
import '../../feature/auth/pages/login_page.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../feature/events/models/event_model.dart';

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
        pageBuilder: (context, state) {
          return const MaterialPage(child: HomePage());
        },
        routes: [
          GoRoute(
              path: "newEvent",
              pageBuilder: (context, state) {
                return MaterialPage(
                  child: CreateNeweventPage(),
                );
              }),
          GoRoute(
              path: "event",
              pageBuilder: (context, state) {
                Event args = state.extra as Event;
                return MaterialPage(
                  child: EventPage(args: args),
                );
              }),
        ],
      ),
      GoRoute(
        path: '/signin',
        pageBuilder: (context, state) =>
            const MaterialPage(child: SigninPage()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          inLoginPage = !inLoginPage;
          return const MaterialPage(
            child: LoginPage(),
          );
        },
      ),
    ],
    redirect: (context, state) {
      final isProtectedRoute = state.matchedLocation != '/login' &&
          state.matchedLocation != '/signin';
      if (isProtectedRoute && !isAuthenticated) {
        return '/login';
      } else if (!isProtectedRoute && isAuthenticated) {
        return '/';
      }
      return null;
    },
  );
}
