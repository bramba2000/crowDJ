import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_data_source.dart';
import '../data/user_data_source.dart';
import '../models/user_props.dart';
import 'authentication_provider.dart';
import 'state/authentication_state.dart';

part 'utils_auth_provider.g.dart';

@riverpod
String? userId(UserIdRef ref) {
  return ref.watch(
      authNotifierProvider(defaultAuthDataSource, defaultUserDataSource)
          .select((value) => switch (value) {
                AuthenticationStateAuthenticated(:final user) => user.uid,
                _ => null,
              }));
}

@riverpod
UserProps? userProps(UserPropsRef ref) {
  return ref.watch(
      authNotifierProvider(defaultAuthDataSource, defaultUserDataSource)
          .select((value) => switch (value) {
                AuthenticationStateAuthenticated(:final userProps) => userProps,
                _ => null,
              }));
}

@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) => ref.watch(
        authNotifierProvider(defaultAuthDataSource, defaultUserDataSource))
    is AuthenticationStateAuthenticated;
