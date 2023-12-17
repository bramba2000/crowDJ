// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import '../utils/location_helper.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@Freezed(unionKey: 'accessibility', unionValueCase: FreezedUnionCase.none)
class Event with _$Event {
  const Event._();

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
    required String? password,
  }) = PrivateEvent;

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

enum EventStatus {
  @JsonValue('past')
  past,
  @JsonValue('ongoing')
  ongoing,
  @JsonValue('upcoming')
  upcoming,
}

enum EventAccessibility {
  @JsonValue('public')
  public,
  @JsonValue('private')
  private,
}
