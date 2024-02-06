// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EventData {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get maxPeople => throw _privateConstructorUsedError;
  GeoPoint get location => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  String get creatorId => throw _privateConstructorUsedError;
  String get genre => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EventDataCopyWith<EventData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventDataCopyWith<$Res> {
  factory $EventDataCopyWith(EventData value, $Res Function(EventData) then) =
      _$EventDataCopyWithImpl<$Res, EventData>;
  @useResult
  $Res call(
      {String title,
      String description,
      int maxPeople,
      GeoPoint location,
      DateTime startTime,
      String creatorId,
      String genre,
      bool isPrivate});
}

/// @nodoc
class _$EventDataCopyWithImpl<$Res, $Val extends EventData>
    implements $EventDataCopyWith<$Res> {
  _$EventDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? maxPeople = null,
    Object? location = null,
    Object? startTime = null,
    Object? creatorId = null,
    Object? genre = null,
    Object? isPrivate = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      maxPeople: null == maxPeople
          ? _value.maxPeople
          : maxPeople // ignore: cast_nullable_to_non_nullable
              as int,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as GeoPoint,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      genre: null == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventDataImplCopyWith<$Res>
    implements $EventDataCopyWith<$Res> {
  factory _$$EventDataImplCopyWith(
          _$EventDataImpl value, $Res Function(_$EventDataImpl) then) =
      __$$EventDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String description,
      int maxPeople,
      GeoPoint location,
      DateTime startTime,
      String creatorId,
      String genre,
      bool isPrivate});
}

/// @nodoc
class __$$EventDataImplCopyWithImpl<$Res>
    extends _$EventDataCopyWithImpl<$Res, _$EventDataImpl>
    implements _$$EventDataImplCopyWith<$Res> {
  __$$EventDataImplCopyWithImpl(
      _$EventDataImpl _value, $Res Function(_$EventDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? maxPeople = null,
    Object? location = null,
    Object? startTime = null,
    Object? creatorId = null,
    Object? genre = null,
    Object? isPrivate = null,
  }) {
    return _then(_$EventDataImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      maxPeople: null == maxPeople
          ? _value.maxPeople
          : maxPeople // ignore: cast_nullable_to_non_nullable
              as int,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as GeoPoint,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      genre: null == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$EventDataImpl implements _EventData {
  const _$EventDataImpl(
      {required this.title,
      required this.description,
      required this.maxPeople,
      required this.location,
      required this.startTime,
      required this.creatorId,
      required this.genre,
      this.isPrivate = false});

  @override
  final String title;
  @override
  final String description;
  @override
  final int maxPeople;
  @override
  final GeoPoint location;
  @override
  final DateTime startTime;
  @override
  final String creatorId;
  @override
  final String genre;
  @override
  @JsonKey()
  final bool isPrivate;

  @override
  String toString() {
    return 'EventData(title: $title, description: $description, maxPeople: $maxPeople, location: $location, startTime: $startTime, creatorId: $creatorId, genre: $genre, isPrivate: $isPrivate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventDataImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.maxPeople, maxPeople) ||
                other.maxPeople == maxPeople) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, description, maxPeople,
      location, startTime, creatorId, genre, isPrivate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventDataImplCopyWith<_$EventDataImpl> get copyWith =>
      __$$EventDataImplCopyWithImpl<_$EventDataImpl>(this, _$identity);
}

abstract class _EventData implements EventData {
  const factory _EventData(
      {required final String title,
      required final String description,
      required final int maxPeople,
      required final GeoPoint location,
      required final DateTime startTime,
      required final String creatorId,
      required final String genre,
      final bool isPrivate}) = _$EventDataImpl;

  @override
  String get title;
  @override
  String get description;
  @override
  int get maxPeople;
  @override
  GeoPoint get location;
  @override
  DateTime get startTime;
  @override
  String get creatorId;
  @override
  String get genre;
  @override
  bool get isPrivate;
  @override
  @JsonKey(ignore: true)
  _$$EventDataImplCopyWith<_$EventDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
