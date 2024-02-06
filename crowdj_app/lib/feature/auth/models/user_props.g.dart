// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPropsImpl _$$UserPropsImplFromJson(Map<String, dynamic> json) =>
    _$UserPropsImpl(
      name: json['name'] as String,
      surname: json['surname'] as String,
      email: json['email'] as String,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$UserPropsImplToJson(_$UserPropsImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'runtimeType': instance.$type,
    };

const _$UserTypeEnumMap = {
  UserType.participant: 'participant',
  UserType.dj: 'dj',
};

_$DjUserPropsImpl _$$DjUserPropsImplFromJson(Map<String, dynamic> json) =>
    _$DjUserPropsImpl(
      name: json['name'] as String,
      surname: json['surname'] as String,
      email: json['email'] as String,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      spotifyAuthenticated: json['spotifyAuthenticated'] as bool?,
      refreshToken: json['refreshToken'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$DjUserPropsImplToJson(_$DjUserPropsImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'spotifyAuthenticated': instance.spotifyAuthenticated,
      'refreshToken': instance.refreshToken,
      'runtimeType': instance.$type,
    };
