// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Participation _$ParticipationFromJson(Map<String, dynamic> json) {
  return _Participation.fromJson(json);
}

/// @nodoc
mixin _$Participation {
  String get eventId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get joinedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ParticipationCopyWith<Participation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipationCopyWith<$Res> {
  factory $ParticipationCopyWith(
          Participation value, $Res Function(Participation) then) =
      _$ParticipationCopyWithImpl<$Res, Participation>;
  @useResult
  $Res call({String eventId, String userId, DateTime joinedAt});
}

/// @nodoc
class _$ParticipationCopyWithImpl<$Res, $Val extends Participation>
    implements $ParticipationCopyWith<$Res> {
  _$ParticipationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? userId = null,
    Object? joinedAt = null,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParticipationImplCopyWith<$Res>
    implements $ParticipationCopyWith<$Res> {
  factory _$$ParticipationImplCopyWith(
          _$ParticipationImpl value, $Res Function(_$ParticipationImpl) then) =
      __$$ParticipationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String eventId, String userId, DateTime joinedAt});
}

/// @nodoc
class __$$ParticipationImplCopyWithImpl<$Res>
    extends _$ParticipationCopyWithImpl<$Res, _$ParticipationImpl>
    implements _$$ParticipationImplCopyWith<$Res> {
  __$$ParticipationImplCopyWithImpl(
      _$ParticipationImpl _value, $Res Function(_$ParticipationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? userId = null,
    Object? joinedAt = null,
  }) {
    return _then(_$ParticipationImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParticipationImpl implements _Participation {
  const _$ParticipationImpl(
      {required this.eventId, required this.userId, required this.joinedAt});

  factory _$ParticipationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParticipationImplFromJson(json);

  @override
  final String eventId;
  @override
  final String userId;
  @override
  final DateTime joinedAt;

  @override
  String toString() {
    return 'Participation(eventId: $eventId, userId: $userId, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipationImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, eventId, userId, joinedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipationImplCopyWith<_$ParticipationImpl> get copyWith =>
      __$$ParticipationImplCopyWithImpl<_$ParticipationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParticipationImplToJson(
      this,
    );
  }
}

abstract class _Participation implements Participation {
  const factory _Participation(
      {required final String eventId,
      required final String userId,
      required final DateTime joinedAt}) = _$ParticipationImpl;

  factory _Participation.fromJson(Map<String, dynamic> json) =
      _$ParticipationImpl.fromJson;

  @override
  String get eventId;
  @override
  String get userId;
  @override
  DateTime get joinedAt;
  @override
  @JsonKey(ignore: true)
  _$$ParticipationImplCopyWith<_$ParticipationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
