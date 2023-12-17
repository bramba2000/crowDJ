// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_props.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserProps _$UserPropsFromJson(Map<String, dynamic> json) {
  return _UserProps.fromJson(json);
}

/// @nodoc
mixin _$UserProps {
  String get name => throw _privateConstructorUsedError;
  String get surname => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  UserType get userType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserPropsCopyWith<UserProps> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPropsCopyWith<$Res> {
  factory $UserPropsCopyWith(UserProps value, $Res Function(UserProps) then) =
      _$UserPropsCopyWithImpl<$Res, UserProps>;
  @useResult
  $Res call({String name, String surname, String email, UserType userType});
}

/// @nodoc
class _$UserPropsCopyWithImpl<$Res, $Val extends UserProps>
    implements $UserPropsCopyWith<$Res> {
  _$UserPropsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? surname = null,
    Object? email = null,
    Object? userType = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      surname: null == surname
          ? _value.surname
          : surname // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      userType: null == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as UserType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPropsImplCopyWith<$Res>
    implements $UserPropsCopyWith<$Res> {
  factory _$$UserPropsImplCopyWith(
          _$UserPropsImpl value, $Res Function(_$UserPropsImpl) then) =
      __$$UserPropsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String surname, String email, UserType userType});
}

/// @nodoc
class __$$UserPropsImplCopyWithImpl<$Res>
    extends _$UserPropsCopyWithImpl<$Res, _$UserPropsImpl>
    implements _$$UserPropsImplCopyWith<$Res> {
  __$$UserPropsImplCopyWithImpl(
      _$UserPropsImpl _value, $Res Function(_$UserPropsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? surname = null,
    Object? email = null,
    Object? userType = null,
  }) {
    return _then(_$UserPropsImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      surname: null == surname
          ? _value.surname
          : surname // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      userType: null == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as UserType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPropsImpl implements _UserProps {
  const _$UserPropsImpl(
      {required this.name,
      required this.surname,
      required this.email,
      required this.userType});

  factory _$UserPropsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPropsImplFromJson(json);

  @override
  final String name;
  @override
  final String surname;
  @override
  final String email;
  @override
  final UserType userType;

  @override
  String toString() {
    return 'UserProps(name: $name, surname: $surname, email: $email, userType: $userType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPropsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.surname, surname) || other.surname == surname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.userType, userType) ||
                other.userType == userType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, surname, email, userType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPropsImplCopyWith<_$UserPropsImpl> get copyWith =>
      __$$UserPropsImplCopyWithImpl<_$UserPropsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPropsImplToJson(
      this,
    );
  }
}

abstract class _UserProps implements UserProps {
  const factory _UserProps(
      {required final String name,
      required final String surname,
      required final String email,
      required final UserType userType}) = _$UserPropsImpl;

  factory _UserProps.fromJson(Map<String, dynamic> json) =
      _$UserPropsImpl.fromJson;

  @override
  String get name;
  @override
  String get surname;
  @override
  String get email;
  @override
  UserType get userType;
  @override
  @JsonKey(ignore: true)
  _$$UserPropsImplCopyWith<_$UserPropsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
