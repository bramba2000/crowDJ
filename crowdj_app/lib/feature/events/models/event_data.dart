import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_data.freezed.dart';

@freezed
class EventData with _$EventData {
  const factory EventData({
    required String title,
    required String description,
    required int maxPeople,
    required GeoPoint location,
    required DateTime startTime,
    required String creatorId,
    required String genre,
    @Default(false) bool isPrivate,
  }) = _EventData;
}
