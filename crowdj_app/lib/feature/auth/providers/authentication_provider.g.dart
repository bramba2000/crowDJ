// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authNotifierHash() => r'0dcd7e0b7272dd49a0e10c501ee11ae112793d27';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$AuthNotifier
    extends BuildlessAutoDisposeNotifier<AuthenticationState> {
  late final AuthDataSource firebaseAuth;
  late final UserDataSource userDataSource;

  AuthenticationState build(
    AuthDataSource firebaseAuth,
    UserDataSource userDataSource,
  );
}

/// [AuthNotifier] is a riverpod [NotifierProvider] that manage the authentication state of the application.
/// It provides methods for signing in and signing up a user using email and password.
/// The state of authentication is updated based on the success or failure of these operations.
///
/// see also [AuthenticationState]
///
/// Copied from [AuthNotifier].
@ProviderFor(AuthNotifier)
const authNotifierProvider = AuthNotifierFamily();

/// [AuthNotifier] is a riverpod [NotifierProvider] that manage the authentication state of the application.
/// It provides methods for signing in and signing up a user using email and password.
/// The state of authentication is updated based on the success or failure of these operations.
///
/// see also [AuthenticationState]
///
/// Copied from [AuthNotifier].
class AuthNotifierFamily extends Family<AuthenticationState> {
  /// [AuthNotifier] is a riverpod [NotifierProvider] that manage the authentication state of the application.
  /// It provides methods for signing in and signing up a user using email and password.
  /// The state of authentication is updated based on the success or failure of these operations.
  ///
  /// see also [AuthenticationState]
  ///
  /// Copied from [AuthNotifier].
  const AuthNotifierFamily();

  /// [AuthNotifier] is a riverpod [NotifierProvider] that manage the authentication state of the application.
  /// It provides methods for signing in and signing up a user using email and password.
  /// The state of authentication is updated based on the success or failure of these operations.
  ///
  /// see also [AuthenticationState]
  ///
  /// Copied from [AuthNotifier].
  AuthNotifierProvider call(
    AuthDataSource firebaseAuth,
    UserDataSource userDataSource,
  ) {
    return AuthNotifierProvider(
      firebaseAuth,
      userDataSource,
    );
  }

  @override
  AuthNotifierProvider getProviderOverride(
    covariant AuthNotifierProvider provider,
  ) {
    return call(
      provider.firebaseAuth,
      provider.userDataSource,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'authNotifierProvider';
}

/// [AuthNotifier] is a riverpod [NotifierProvider] that manage the authentication state of the application.
/// It provides methods for signing in and signing up a user using email and password.
/// The state of authentication is updated based on the success or failure of these operations.
///
/// see also [AuthenticationState]
///
/// Copied from [AuthNotifier].
class AuthNotifierProvider
    extends AutoDisposeNotifierProviderImpl<AuthNotifier, AuthenticationState> {
  /// [AuthNotifier] is a riverpod [NotifierProvider] that manage the authentication state of the application.
  /// It provides methods for signing in and signing up a user using email and password.
  /// The state of authentication is updated based on the success or failure of these operations.
  ///
  /// see also [AuthenticationState]
  ///
  /// Copied from [AuthNotifier].
  AuthNotifierProvider(
    AuthDataSource firebaseAuth,
    UserDataSource userDataSource,
  ) : this._internal(
          () => AuthNotifier()
            ..firebaseAuth = firebaseAuth
            ..userDataSource = userDataSource,
          from: authNotifierProvider,
          name: r'authNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$authNotifierHash,
          dependencies: AuthNotifierFamily._dependencies,
          allTransitiveDependencies:
              AuthNotifierFamily._allTransitiveDependencies,
          firebaseAuth: firebaseAuth,
          userDataSource: userDataSource,
        );

  AuthNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.firebaseAuth,
    required this.userDataSource,
  }) : super.internal();

  final AuthDataSource firebaseAuth;
  final UserDataSource userDataSource;

  @override
  AuthenticationState runNotifierBuild(
    covariant AuthNotifier notifier,
  ) {
    return notifier.build(
      firebaseAuth,
      userDataSource,
    );
  }

  @override
  Override overrideWith(AuthNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AuthNotifierProvider._internal(
        () => create()
          ..firebaseAuth = firebaseAuth
          ..userDataSource = userDataSource,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        firebaseAuth: firebaseAuth,
        userDataSource: userDataSource,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<AuthNotifier, AuthenticationState>
      createElement() {
    return _AuthNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuthNotifierProvider &&
        other.firebaseAuth == firebaseAuth &&
        other.userDataSource == userDataSource;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, firebaseAuth.hashCode);
    hash = _SystemHash.combine(hash, userDataSource.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AuthNotifierRef on AutoDisposeNotifierProviderRef<AuthenticationState> {
  /// The parameter `firebaseAuth` of this provider.
  AuthDataSource get firebaseAuth;

  /// The parameter `userDataSource` of this provider.
  UserDataSource get userDataSource;
}

class _AuthNotifierProviderElement extends AutoDisposeNotifierProviderElement<
    AuthNotifier, AuthenticationState> with AuthNotifierRef {
  _AuthNotifierProviderElement(super.provider);

  @override
  AuthDataSource get firebaseAuth =>
      (origin as AuthNotifierProvider).firebaseAuth;
  @override
  UserDataSource get userDataSource =>
      (origin as AuthNotifierProvider).userDataSource;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
