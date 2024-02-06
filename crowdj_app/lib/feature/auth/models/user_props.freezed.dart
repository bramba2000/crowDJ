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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProps _$UserPropsFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'default':
      return _UserProps.fromJson(json);
    case 'dj':
      return DjUserProps.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'UserProps',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$UserProps {
  String get name => throw _privateConstructorUsedError;
  String get surname => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  UserType get userType => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String name, String surname, String email, UserType userType)
        $default, {
    required TResult Function(String name, String surname, String email,
            UserType userType, bool? spotifyAuthenticated, String? refreshToken)
        dj,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String name, String surname, String email, UserType userType)?
        $default, {
    TResult? Function(
            String name,
            String surname,
            String email,
            UserType userType,
            bool? spotifyAuthenticated,
            String? refreshToken)?
        dj,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String name, String surname, String email, UserType userType)?
        $default, {
    TResult Function(
            String name,
            String surname,
            String email,
            UserType userType,
            bool? spotifyAuthenticated,
            String? refreshToken)?
        dj,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UserProps value) $default, {
    required TResult Function(DjUserProps value) dj,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UserProps value)? $default, {
    TResult? Function(DjUserProps value)? dj,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UserProps value)? $default, {
    TResult Function(DjUserProps value)? dj,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
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
      required this.userType,
      final String? $type})
      : $type = $type ?? 'default';

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

  @JsonKey(name: 'runtimeType')
  final String $type;

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
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String name, String surname, String email, UserType userType)
        $default, {
    required TResult Function(String name, String surname, String email,
            UserType userType, bool? spotifyAuthenticated, String? refreshToken)
        dj,
  }) {
    return $default(name, surname, email, userType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String name, String surname, String email, UserType userType)?
        $default, {
    TResult? Function(
            String name,
            String surname,
            String email,
            UserType userType,
            bool? spotifyAuthenticated,
            String? refreshToken)?
        dj,
  }) {
    return $default?.call(name, surname, email, userType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String name, String surname, String email, UserType userType)?
        $default, {
    TResult Function(
            String name,
            String surname,
            String email,
            UserType userType,
            bool? spotifyAuthenticated,
            String? refreshToken)?
        dj,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(name, surname, email, userType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UserProps value) $default, {
    required TResult Function(DjUserProps value) dj,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UserProps value)? $default, {
    TResult? Function(DjUserProps value)? dj,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UserProps value)? $default, {
    TResult Function(DjUserProps value)? dj,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPropsImplToJson(
      this,
    );
  }
}

abstract class _UserProps implements UserProps, UserPropsBase {
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

/// @nodoc
abstract class _$$DjUserPropsImplCopyWith<$Res>
    implements $UserPropsCopyWith<$Res> {
  factory _$$DjUserPropsImplCopyWith(
          _$DjUserPropsImpl value, $Res Function(_$DjUserPropsImpl) then) =
      __$$DjUserPropsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String surname,
      String email,
      UserType userType,
      bool? spotifyAuthenticated,
      String? refreshToken});
}

/// @nodoc
class __$$DjUserPropsImplCopyWithImpl<$Res>
    extends _$UserPropsCopyWithImpl<$Res, _$DjUserPropsImpl>
    implements _$$DjUserPropsImplCopyWith<$Res> {
  __$$DjUserPropsImplCopyWithImpl(
      _$DjUserPropsImpl _value, $Res Function(_$DjUserPropsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? surname = null,
    Object? email = null,
    Object? userType = null,
    Object? spotifyAuthenticated = freezed,
    Object? refreshToken = freezed,
  }) {
    return _then(_$DjUserPropsImpl(
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
      spotifyAuthenticated: freezed == spotifyAuthenticated
          ? _value.spotifyAuthenticated
          : spotifyAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool?,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DjUserPropsImpl implements DjUserProps {
  const _$DjUserPropsImpl(
      {required this.name,
      required this.surname,
      required this.email,
      required this.userType,
      this.spotifyAuthenticated,
      this.refreshToken,
      final String? $type})
      : assert(spotifyAuthenticated != true || refreshToken != null,
            'The refresh token must be provided if the user is authenticated with Spotify'),
        $type = $type ?? 'dj';

  factory _$DjUserPropsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DjUserPropsImplFromJson(json);

  @override
  final String name;
  @override
  final String surname;
  @override
  final String email;
  @override
  final UserType userType;
  @override
  final bool? spotifyAuthenticated;
  @override
  final String? refreshToken;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'UserProps.dj(name: $name, surname: $surname, email: $email, userType: $userType, spotifyAuthenticated: $spotifyAuthenticated, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DjUserPropsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.surname, surname) || other.surname == surname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.userType, userType) ||
                other.userType == userType) &&
            (identical(other.spotifyAuthenticated, spotifyAuthenticated) ||
                other.spotifyAuthenticated == spotifyAuthenticated) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, surname, email, userType,
      spotifyAuthenticated, refreshToken);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DjUserPropsImplCopyWith<_$DjUserPropsImpl> get copyWith =>
      __$$DjUserPropsImplCopyWithImpl<_$DjUserPropsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String name, String surname, String email, UserType userType)
        $default, {
    required TResult Function(String name, String surname, String email,
            UserType userType, bool? spotifyAuthenticated, String? refreshToken)
        dj,
  }) {
    return dj(
        name, surname, email, userType, spotifyAuthenticated, refreshToken);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String name, String surname, String email, UserType userType)?
        $default, {
    TResult? Function(
            String name,
            String surname,
            String email,
            UserType userType,
            bool? spotifyAuthenticated,
            String? refreshToken)?
        dj,
  }) {
    return dj?.call(
        name, surname, email, userType, spotifyAuthenticated, refreshToken);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String name, String surname, String email, UserType userType)?
        $default, {
    TResult Function(
            String name,
            String surname,
            String email,
            UserType userType,
            bool? spotifyAuthenticated,
            String? refreshToken)?
        dj,
    required TResult orElse(),
  }) {
    if (dj != null) {
      return dj(
          name, surname, email, userType, spotifyAuthenticated, refreshToken);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UserProps value) $default, {
    required TResult Function(DjUserProps value) dj,
  }) {
    return dj(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UserProps value)? $default, {
    TResult? Function(DjUserProps value)? dj,
  }) {
    return dj?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UserProps value)? $default, {
    TResult Function(DjUserProps value)? dj,
    required TResult orElse(),
  }) {
    if (dj != null) {
      return dj(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DjUserPropsImplToJson(
      this,
    );
  }
}

abstract class DjUserProps implements UserProps, UserPropsBase {
  const factory DjUserProps(
      {required final String name,
      required final String surname,
      required final String email,
      required final UserType userType,
      final bool? spotifyAuthenticated,
      final String? refreshToken}) = _$DjUserPropsImpl;

  factory DjUserProps.fromJson(Map<String, dynamic> json) =
      _$DjUserPropsImpl.fromJson;

  @override
  String get name;
  @override
  String get surname;
  @override
  String get email;
  @override
  UserType get userType;
  bool? get spotifyAuthenticated;
  String? get refreshToken;
  @override
  @JsonKey(ignore: true)
  _$$DjUserPropsImplCopyWith<_$DjUserPropsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
