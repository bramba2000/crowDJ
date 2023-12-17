// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Event _$EventFromJson(Map<String, dynamic> json) {
  switch (json['accessibility']) {
    case 'private':
      return PrivateEvent.fromJson(json);
    case 'public':
      return PublicEvent.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'accessibility', 'Event',
          'Invalid union type "${json['accessibility']}"!');
  }
}

/// @nodoc
mixin _$Event {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get maxPeople => throw _privateConstructorUsedError;
  @JsonKey(fromJson: LocationHelper.fromJson, toJson: LocationHelper.toJson)
  GeoFirePoint get location => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  String get creatorId => throw _privateConstructorUsedError;
  String get genre => throw _privateConstructorUsedError;
  EventStatus get status => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status,
            String? password)
        private,
    required TResult Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status)
        public,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status,
            String? password)?
        private,
    TResult? Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status)?
        public,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status,
            String? password)?
        private,
    TResult Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status)?
        public,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PrivateEvent value) private,
    required TResult Function(PublicEvent value) public,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PrivateEvent value)? private,
    TResult? Function(PublicEvent value)? public,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PrivateEvent value)? private,
    TResult Function(PublicEvent value)? public,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res, Event>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      int maxPeople,
      @JsonKey(fromJson: LocationHelper.fromJson, toJson: LocationHelper.toJson)
      GeoFirePoint location,
      DateTime startTime,
      String creatorId,
      String genre,
      EventStatus status});
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? maxPeople = null,
    Object? location = null,
    Object? startTime = null,
    Object? creatorId = null,
    Object? genre = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
              as GeoFirePoint,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivateEventImplCopyWith<$Res>
    implements $EventCopyWith<$Res> {
  factory _$$PrivateEventImplCopyWith(
          _$PrivateEventImpl value, $Res Function(_$PrivateEventImpl) then) =
      __$$PrivateEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      int maxPeople,
      @JsonKey(fromJson: LocationHelper.fromJson, toJson: LocationHelper.toJson)
      GeoFirePoint location,
      DateTime startTime,
      String creatorId,
      String genre,
      EventStatus status,
      String? password});
}

/// @nodoc
class __$$PrivateEventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$PrivateEventImpl>
    implements _$$PrivateEventImplCopyWith<$Res> {
  __$$PrivateEventImplCopyWithImpl(
      _$PrivateEventImpl _value, $Res Function(_$PrivateEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? maxPeople = null,
    Object? location = null,
    Object? startTime = null,
    Object? creatorId = null,
    Object? genre = null,
    Object? status = null,
    Object? password = freezed,
  }) {
    return _then(_$PrivateEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
              as GeoFirePoint,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivateEventImpl extends PrivateEvent {
  const _$PrivateEventImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.maxPeople,
      @JsonKey(fromJson: LocationHelper.fromJson, toJson: LocationHelper.toJson)
      required this.location,
      required this.startTime,
      required this.creatorId,
      required this.genre,
      required this.status,
      required this.password,
      final String? $type})
      : $type = $type ?? 'private',
        super._();

  factory _$PrivateEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivateEventImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final int maxPeople;
  @override
  @JsonKey(fromJson: LocationHelper.fromJson, toJson: LocationHelper.toJson)
  final GeoFirePoint location;
  @override
  final DateTime startTime;
  @override
  final String creatorId;
  @override
  final String genre;
  @override
  final EventStatus status;
  @override
  final String? password;

  @JsonKey(name: 'accessibility')
  final String $type;

  @override
  String toString() {
    return 'Event.private(id: $id, title: $title, description: $description, maxPeople: $maxPeople, location: $location, startTime: $startTime, creatorId: $creatorId, genre: $genre, status: $status, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivateEventImpl &&
            (identical(other.id, id) || other.id == id) &&
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
            (identical(other.status, status) || other.status == status) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description,
      maxPeople, location, startTime, creatorId, genre, status, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivateEventImplCopyWith<_$PrivateEventImpl> get copyWith =>
      __$$PrivateEventImplCopyWithImpl<_$PrivateEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status,
            String? password)
        private,
    required TResult Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status)
        public,
  }) {
    return private(id, title, description, maxPeople, location, startTime,
        creatorId, genre, status, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status,
            String? password)?
        private,
    TResult? Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status)?
        public,
  }) {
    return private?.call(id, title, description, maxPeople, location, startTime,
        creatorId, genre, status, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status,
            String? password)?
        private,
    TResult Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status)?
        public,
    required TResult orElse(),
  }) {
    if (private != null) {
      return private(id, title, description, maxPeople, location, startTime,
          creatorId, genre, status, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PrivateEvent value) private,
    required TResult Function(PublicEvent value) public,
  }) {
    return private(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PrivateEvent value)? private,
    TResult? Function(PublicEvent value)? public,
  }) {
    return private?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PrivateEvent value)? private,
    TResult Function(PublicEvent value)? public,
    required TResult orElse(),
  }) {
    if (private != null) {
      return private(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivateEventImplToJson(
      this,
    );
  }
}

abstract class PrivateEvent extends Event {
  const factory PrivateEvent(
      {required final String id,
      required final String title,
      required final String description,
      required final int maxPeople,
      @JsonKey(fromJson: LocationHelper.fromJson, toJson: LocationHelper.toJson)
      required final GeoFirePoint location,
      required final DateTime startTime,
      required final String creatorId,
      required final String genre,
      required final EventStatus status,
      required final String? password}) = _$PrivateEventImpl;
  const PrivateEvent._() : super._();

  factory PrivateEvent.fromJson(Map<String, dynamic> json) =
      _$PrivateEventImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  int get maxPeople;
  @override
  @JsonKey(fromJson: LocationHelper.fromJson, toJson: LocationHelper.toJson)
  GeoFirePoint get location;
  @override
  DateTime get startTime;
  @override
  String get creatorId;
  @override
  String get genre;
  @override
  EventStatus get status;
  String? get password;
  @override
  @JsonKey(ignore: true)
  _$$PrivateEventImplCopyWith<_$PrivateEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PublicEventImplCopyWith<$Res>
    implements $EventCopyWith<$Res> {
  factory _$$PublicEventImplCopyWith(
          _$PublicEventImpl value, $Res Function(_$PublicEventImpl) then) =
      __$$PublicEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      int maxPeople,
      @JsonKey(fromJson: LocationHelper.fromJson, toJson: LocationHelper.toJson)
      GeoFirePoint location,
      DateTime startTime,
      String creatorId,
      String genre,
      EventStatus status});
}

/// @nodoc
class __$$PublicEventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$PublicEventImpl>
    implements _$$PublicEventImplCopyWith<$Res> {
  __$$PublicEventImplCopyWithImpl(
      _$PublicEventImpl _value, $Res Function(_$PublicEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? maxPeople = null,
    Object? location = null,
    Object? startTime = null,
    Object? creatorId = null,
    Object? genre = null,
    Object? status = null,
  }) {
    return _then(_$PublicEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
              as GeoFirePoint,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PublicEventImpl extends PublicEvent {
  const _$PublicEventImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.maxPeople,
      @JsonKey(fromJson: LocationHelper.fromJson, toJson: LocationHelper.toJson)
      required this.location,
      required this.startTime,
      required this.creatorId,
      required this.genre,
      required this.status,
      final String? $type})
      : $type = $type ?? 'public',
        super._();

  factory _$PublicEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublicEventImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final int maxPeople;
  @override
  @JsonKey(fromJson: LocationHelper.fromJson, toJson: LocationHelper.toJson)
  final GeoFirePoint location;
  @override
  final DateTime startTime;
  @override
  final String creatorId;
  @override
  final String genre;
  @override
  final EventStatus status;

  @JsonKey(name: 'accessibility')
  final String $type;

  @override
  String toString() {
    return 'Event.public(id: $id, title: $title, description: $description, maxPeople: $maxPeople, location: $location, startTime: $startTime, creatorId: $creatorId, genre: $genre, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublicEventImpl &&
            (identical(other.id, id) || other.id == id) &&
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
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description,
      maxPeople, location, startTime, creatorId, genre, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PublicEventImplCopyWith<_$PublicEventImpl> get copyWith =>
      __$$PublicEventImplCopyWithImpl<_$PublicEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status,
            String? password)
        private,
    required TResult Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status)
        public,
  }) {
    return public(id, title, description, maxPeople, location, startTime,
        creatorId, genre, status);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status,
            String? password)?
        private,
    TResult? Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status)?
        public,
  }) {
    return public?.call(id, title, description, maxPeople, location, startTime,
        creatorId, genre, status);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status,
            String? password)?
        private,
    TResult Function(
            String id,
            String title,
            String description,
            int maxPeople,
            @JsonKey(
                fromJson: LocationHelper.fromJson,
                toJson: LocationHelper.toJson)
            GeoFirePoint location,
            DateTime startTime,
            String creatorId,
            String genre,
            EventStatus status)?
        public,
    required TResult orElse(),
  }) {
    if (public != null) {
      return public(id, title, description, maxPeople, location, startTime,
          creatorId, genre, status);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PrivateEvent value) private,
    required TResult Function(PublicEvent value) public,
  }) {
    return public(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PrivateEvent value)? private,
    TResult? Function(PublicEvent value)? public,
  }) {
    return public?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PrivateEvent value)? private,
    TResult Function(PublicEvent value)? public,
    required TResult orElse(),
  }) {
    if (public != null) {
      return public(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PublicEventImplToJson(
      this,
    );
  }
}

abstract class PublicEvent extends Event {
  const factory PublicEvent(
      {required final String id,
      required final String title,
      required final String description,
      required final int maxPeople,
      @JsonKey(fromJson: LocationHelper.fromJson, toJson: LocationHelper.toJson)
      required final GeoFirePoint location,
      required final DateTime startTime,
      required final String creatorId,
      required final String genre,
      required final EventStatus status}) = _$PublicEventImpl;
  const PublicEvent._() : super._();

  factory PublicEvent.fromJson(Map<String, dynamic> json) =
      _$PublicEventImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  int get maxPeople;
  @override
  @JsonKey(fromJson: LocationHelper.fromJson, toJson: LocationHelper.toJson)
  GeoFirePoint get location;
  @override
  DateTime get startTime;
  @override
  String get creatorId;
  @override
  String get genre;
  @override
  EventStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$PublicEventImplCopyWith<_$PublicEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
