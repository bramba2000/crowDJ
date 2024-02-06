// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrackMetadata _$TrackMetadataFromJson(Map<String, dynamic> json) {
  return _TrackMetadata.fromJson(json);
}

/// @nodoc
mixin _$TrackMetadata {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get artist => throw _privateConstructorUsedError;
  String get album => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String? get proposedBy => throw _privateConstructorUsedError;
  bool get played => throw _privateConstructorUsedError;
  List<String> get voters => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TrackMetadataCopyWith<TrackMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackMetadataCopyWith<$Res> {
  factory $TrackMetadataCopyWith(
          TrackMetadata value, $Res Function(TrackMetadata) then) =
      _$TrackMetadataCopyWithImpl<$Res, TrackMetadata>;
  @useResult
  $Res call(
      {String id,
      String name,
      String artist,
      String album,
      String imageUrl,
      String? proposedBy,
      bool played,
      List<String> voters});
}

/// @nodoc
class _$TrackMetadataCopyWithImpl<$Res, $Val extends TrackMetadata>
    implements $TrackMetadataCopyWith<$Res> {
  _$TrackMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? artist = null,
    Object? album = null,
    Object? imageUrl = null,
    Object? proposedBy = freezed,
    Object? played = null,
    Object? voters = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      proposedBy: freezed == proposedBy
          ? _value.proposedBy
          : proposedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      played: null == played
          ? _value.played
          : played // ignore: cast_nullable_to_non_nullable
              as bool,
      voters: null == voters
          ? _value.voters
          : voters // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrackMetadataImplCopyWith<$Res>
    implements $TrackMetadataCopyWith<$Res> {
  factory _$$TrackMetadataImplCopyWith(
          _$TrackMetadataImpl value, $Res Function(_$TrackMetadataImpl) then) =
      __$$TrackMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String artist,
      String album,
      String imageUrl,
      String? proposedBy,
      bool played,
      List<String> voters});
}

/// @nodoc
class __$$TrackMetadataImplCopyWithImpl<$Res>
    extends _$TrackMetadataCopyWithImpl<$Res, _$TrackMetadataImpl>
    implements _$$TrackMetadataImplCopyWith<$Res> {
  __$$TrackMetadataImplCopyWithImpl(
      _$TrackMetadataImpl _value, $Res Function(_$TrackMetadataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? artist = null,
    Object? album = null,
    Object? imageUrl = null,
    Object? proposedBy = freezed,
    Object? played = null,
    Object? voters = null,
  }) {
    return _then(_$TrackMetadataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      proposedBy: freezed == proposedBy
          ? _value.proposedBy
          : proposedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      played: null == played
          ? _value.played
          : played // ignore: cast_nullable_to_non_nullable
              as bool,
      voters: null == voters
          ? _value._voters
          : voters // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrackMetadataImpl extends _TrackMetadata {
  const _$TrackMetadataImpl(
      {required this.id,
      required this.name,
      required this.artist,
      required this.album,
      required this.imageUrl,
      this.proposedBy,
      this.played = false,
      final List<String> voters = const []})
      : _voters = voters,
        super._();

  factory _$TrackMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrackMetadataImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String artist;
  @override
  final String album;
  @override
  final String imageUrl;
  @override
  final String? proposedBy;
  @override
  @JsonKey()
  final bool played;
  final List<String> _voters;
  @override
  @JsonKey()
  List<String> get voters {
    if (_voters is EqualUnmodifiableListView) return _voters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_voters);
  }

  @override
  String toString() {
    return 'TrackMetadata(id: $id, name: $name, artist: $artist, album: $album, imageUrl: $imageUrl, proposedBy: $proposedBy, played: $played, voters: $voters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackMetadataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.album, album) || other.album == album) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.proposedBy, proposedBy) ||
                other.proposedBy == proposedBy) &&
            (identical(other.played, played) || other.played == played) &&
            const DeepCollectionEquality().equals(other._voters, _voters));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      artist,
      album,
      imageUrl,
      proposedBy,
      played,
      const DeepCollectionEquality().hash(_voters));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackMetadataImplCopyWith<_$TrackMetadataImpl> get copyWith =>
      __$$TrackMetadataImplCopyWithImpl<_$TrackMetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrackMetadataImplToJson(
      this,
    );
  }
}

abstract class _TrackMetadata extends TrackMetadata {
  const factory _TrackMetadata(
      {required final String id,
      required final String name,
      required final String artist,
      required final String album,
      required final String imageUrl,
      final String? proposedBy,
      final bool played,
      final List<String> voters}) = _$TrackMetadataImpl;
  const _TrackMetadata._() : super._();

  factory _TrackMetadata.fromJson(Map<String, dynamic> json) =
      _$TrackMetadataImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get artist;
  @override
  String get album;
  @override
  String get imageUrl;
  @override
  String? get proposedBy;
  @override
  bool get played;
  @override
  List<String> get voters;
  @override
  @JsonKey(ignore: true)
  _$$TrackMetadataImplCopyWith<_$TrackMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
