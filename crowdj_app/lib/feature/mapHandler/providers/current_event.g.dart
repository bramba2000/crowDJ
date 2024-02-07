// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_event.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsOfUserHash() => r'793071053211133c7fbdf686326250da65d72d6b';

/// See also [eventsOfUser].
@ProviderFor(eventsOfUser)
final eventsOfUserProvider = AutoDisposeFutureProvider<List<Event>>.internal(
  eventsOfUser,
  name: r'eventsOfUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eventsOfUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EventsOfUserRef = AutoDisposeFutureProviderRef<List<Event>>;
String _$createdEventsHash() => r'20d10f796201110aa1f60781086c4fd4f7ea671b';

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
String _$visibleEventsHash() => r'd9f156ff08141bc6edaebe82c3c52a121dedb93e';

/// See also [VisibleEvents].
@ProviderFor(VisibleEvents)
final visibleEventsProvider =
    AutoDisposeNotifierProvider<VisibleEvents, List<Event>>.internal(
  VisibleEvents.new,
  name: r'visibleEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$visibleEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VisibleEvents = AutoDisposeNotifier<List<Event>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
