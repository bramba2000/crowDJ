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
    );

Map<String, dynamic> _$$UserPropsImplToJson(_$UserPropsImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'userType': _$UserTypeEnumMap[instance.userType]!,
    };

const _$UserTypeEnumMap = {
  UserType.PARTICIPANT: 'PARTICIPANT',
  UserType.DJ: 'DJ',
};
