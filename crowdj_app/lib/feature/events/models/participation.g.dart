// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParticipationImpl _$$ParticipationImplFromJson(Map<String, dynamic> json) =>
    _$ParticipationImpl(
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$$ParticipationImplToJson(_$ParticipationImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'userId': instance.userId,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };
