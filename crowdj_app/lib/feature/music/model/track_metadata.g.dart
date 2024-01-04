// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrackMetadataImpl _$$TrackMetadataImplFromJson(Map<String, dynamic> json) =>
    _$TrackMetadataImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      artist: json['artist'] as String,
      album: json['album'] as String,
      imageUrl: json['imageUrl'] as String,
      proposedBy: json['proposedBy'] as String?,
      played: json['played'] as bool? ?? false,
      voters: (json['voters'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TrackMetadataImplToJson(_$TrackMetadataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'artist': instance.artist,
      'album': instance.album,
      'imageUrl': instance.imageUrl,
      'proposedBy': instance.proposedBy,
      'played': instance.played,
      'voters': instance.voters,
    };
