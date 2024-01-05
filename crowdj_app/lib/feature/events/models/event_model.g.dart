// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrivateEventImpl _$$PrivateEventImplFromJson(Map<String, dynamic> json) =>
    _$PrivateEventImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      maxPeople: json['maxPeople'] as int,
      location:
          LocationHelper.fromJson(json['location'] as Map<String, dynamic>),
      startTime: DateTime.parse(json['startTime'] as String),
      creatorId: json['creatorId'] as String,
      genre: json['genre'] as String,
      status: $enumDecode(_$EventStatusEnumMap, json['status']),
      password: json['password'] as String,
      $type: json['accessibility'] as String?,
    );

Map<String, dynamic> _$$PrivateEventImplToJson(_$PrivateEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'maxPeople': instance.maxPeople,
      'location': LocationHelper.toJson(instance.location),
      'startTime': instance.startTime.toIso8601String(),
      'creatorId': instance.creatorId,
      'genre': instance.genre,
      'status': _$EventStatusEnumMap[instance.status]!,
      'password': instance.password,
      'accessibility': instance.$type,
    };

const _$EventStatusEnumMap = {
  EventStatus.past: 'past',
  EventStatus.ongoing: 'ongoing',
  EventStatus.upcoming: 'upcoming',
};

_$PublicEventImpl _$$PublicEventImplFromJson(Map<String, dynamic> json) =>
    _$PublicEventImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      maxPeople: json['maxPeople'] as int,
      location:
          LocationHelper.fromJson(json['location'] as Map<String, dynamic>),
      startTime: DateTime.parse(json['startTime'] as String),
      creatorId: json['creatorId'] as String,
      genre: json['genre'] as String,
      status: $enumDecode(_$EventStatusEnumMap, json['status']),
      $type: json['accessibility'] as String?,
    );

Map<String, dynamic> _$$PublicEventImplToJson(_$PublicEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'maxPeople': instance.maxPeople,
      'location': LocationHelper.toJson(instance.location),
      'startTime': instance.startTime.toIso8601String(),
      'creatorId': instance.creatorId,
      'genre': instance.genre,
      'status': _$EventStatusEnumMap[instance.status]!,
      'accessibility': instance.$type,
    };
