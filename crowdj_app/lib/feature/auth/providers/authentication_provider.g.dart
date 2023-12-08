// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authNotifierHash() => r'9244e807a8f04ad5d57274ea7ec4651f3585aadf';

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

  AuthenticationState build(
    AuthDataSource firebaseAuth,
  );
}

/// See also [AuthNotifier].
@ProviderFor(AuthNotifier)
const authNotifierProvider = AuthNotifierFamily();

/// See also [AuthNotifier].
class AuthNotifierFamily extends Family<AuthenticationState> {
  /// See also [AuthNotifier].
  const AuthNotifierFamily();

  /// See also [AuthNotifier].
  AuthNotifierProvider call(
    AuthDataSource firebaseAuth,
  ) {
    return AuthNotifierProvider(
      firebaseAuth,
    );
  }

  @override
  AuthNotifierProvider getProviderOverride(
    covariant AuthNotifierProvider provider,
  ) {
    return call(
      provider.firebaseAuth,
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

/// See also [AuthNotifier].
class AuthNotifierProvider
    extends AutoDisposeNotifierProviderImpl<AuthNotifier, AuthenticationState> {
  /// See also [AuthNotifier].
  AuthNotifierProvider(
    AuthDataSource firebaseAuth,
  ) : this._internal(
          () => AuthNotifier()..firebaseAuth = firebaseAuth,
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
        );

  AuthNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.firebaseAuth,
  }) : super.internal();

  final AuthDataSource firebaseAuth;

  @override
  AuthenticationState runNotifierBuild(
    covariant AuthNotifier notifier,
  ) {
    return notifier.build(
      firebaseAuth,
    );
  }

  @override
  Override overrideWith(AuthNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AuthNotifierProvider._internal(
        () => create()..firebaseAuth = firebaseAuth,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        firebaseAuth: firebaseAuth,
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
    return other is AuthNotifierProvider && other.firebaseAuth == firebaseAuth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, firebaseAuth.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AuthNotifierRef on AutoDisposeNotifierProviderRef<AuthenticationState> {
  /// The parameter `firebaseAuth` of this provider.
  AuthDataSource get firebaseAuth;
}

class _AuthNotifierProviderElement extends AutoDisposeNotifierProviderElement<
    AuthNotifier, AuthenticationState> with AuthNotifierRef {
  _AuthNotifierProviderElement(super.provider);

  @override
  AuthDataSource get firebaseAuth =>
      (origin as AuthNotifierProvider).firebaseAuth;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
