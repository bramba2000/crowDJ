// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import '../utils/location_helper.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@Freezed(unionKey: 'accessibility', unionValueCase: FreezedUnionCase.none)

/// A union class ([PrivateEvent]|[PublicEvent]) that represents an event.
///
/// Use the factory constructors [Event.private] and [Event.public] to create a
/// new event. See the documentation of those methods for more specific details.
class Event with _$Event {
  static const String collectionName = 'events';

  const Event._();

  /// [PrivateEvent] is an event that is visible and joinable only by those who
  /// know the password and the event ID.
  const factory Event.private({
    required String id,
    required String title,
    required String description,
    required int maxPeople,
    @JsonKey(fromJson: LocationHelper.fromJson, toJson: LocationHelper.toJson)
    required GeoFirePoint location,
    required DateTime startTime,
    required String creatorId,
    required String genre,
    required EventStatus status,
    required String password,
  }) = PrivateEvent;

  /// [PublicEvent] is an event that is visible to everyone and can be joined by
  /// anyone.
  const factory Event.public({
    required String id,
    required String title,
    required String description,
    required int maxPeople,
    @JsonKey(fromJson: LocationHelper.fromJson, toJson: LocationHelper.toJson)
    required GeoFirePoint location,
    required DateTime startTime,
    required String creatorId,
    required String genre,
    required EventStatus status,
  }) = PublicEvent;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  /// If the event is public, returns a [PrivateEvent] with the given password
  /// and the same fields; otherwise, returns the event itself.
  PrivateEvent toPrivate(String password) => this is PrivateEvent
      ? this as PrivateEvent
      : PrivateEvent(
          id: id,
          title: title,
          description: description,
          maxPeople: maxPeople,
          location: location,
          startTime: startTime,
          creatorId: creatorId,
          genre: genre,
          status: status,
          password: password,
        );

  /// If the event is private, returns a [PublicEvent] discarding the password
  /// and the same fields; otherwise, returns the event itself.
  PublicEvent toPublic() => this is PublicEvent
      ? this as PublicEvent
      : PublicEvent(
          id: id,
          title: title,
          description: description,
          maxPeople: maxPeople,
          location: location,
          startTime: startTime,
          creatorId: creatorId,
          genre: genre,
          status: status,
        );
}

/// The status of an event.
enum EventStatus {
  @JsonValue('past')
  past,
  @JsonValue('ongoing')
  ongoing,
  @JsonValue('upcoming')
  upcoming,
}
