import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spotify/spotify.dart';

part 'track_metadata.freezed.dart';
part 'track_metadata.g.dart';

@freezed
class TrackMetadata with _$TrackMetadata {
  static const String collectionName = 'tracks';

  const factory TrackMetadata({
    required String id,
    required String name,
    required String artist,
    required String album,
    required String imageUrl,
    String? proposedBy,
    @Default(false) bool played,
    @Default([]) List<String> voters,
  }) = _TrackMetadata;

  const TrackMetadata._();

  factory TrackMetadata.fromTrack(Track track, {String? proposedBy}) {
    return TrackMetadata(
      id: track.id!,
      name: track.name!,
      artist: track.artists?.first.name ?? '',
      album: track.album?.name ?? '',
      imageUrl: track.album?.images?.first.url ?? '',
      proposedBy: proposedBy ?? '',
      played: false,
    );
  }

  factory TrackMetadata.fromJson(Map<String, dynamic> json) =>
      _$TrackMetadataFromJson(json);
}
