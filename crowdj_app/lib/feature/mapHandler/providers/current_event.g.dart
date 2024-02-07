// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_event.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createdEventsHash() => r'866a8e59bbbfbf28b0459ced4ad654b95f80958b';

/// See also [createdEvents].
@ProviderFor(createdEvents)
final createdEventsProvider = AutoDisposeFutureProvider<List<Event>>.internal(
  createdEvents,
  name: r'createdEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createdEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CreatedEventsRef = AutoDisposeFutureProviderRef<List<Event>>;
String _$currentEventsHash() => r'0c837820ebd379ee5ae2caeca4d440c52a9fa2b6';

/// See also [CurrentEvents].
@ProviderFor(CurrentEvents)
final currentEventsProvider =
    AutoDisposeNotifierProvider<CurrentEvents, List<Event>>.internal(
  CurrentEvents.new,
  name: r'currentEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentEvents = AutoDisposeNotifier<List<Event>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
