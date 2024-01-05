import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify/spotify.dart';
import '../model/track_metadata.dart';

/// Data source class for music related operations
/// This class is responsible for:
/// - Fetching music data from Spotify
/// - CRUD operation on music metadata to Firestore
class MusicDataSource {
  final SpotifyApi _spotifyApi;
  final FirebaseFirestore _instance;

  /// Create a new instance of [MusicDataSource] providing a [SpotifyApi] instance
  /// and optionally a [FirebaseFirestore] instance
  /// If no [FirebaseFirestore] instance is provided, the default one will be used
  MusicDataSource(this._spotifyApi, {FirebaseFirestore? instance})
      : _instance = instance ?? FirebaseFirestore.instance;

  /// Create a new instance of [MusicDataSource] providing Spotify credentials
  /// and optionally a [FirebaseFirestore] instance.
  /// See default constuctor for more details
  factory MusicDataSource.fromCredentials(
      String clientId, String clientSecret, FirebaseFirestore? instance) {
    final credentials = SpotifyApiCredentials(clientId, clientSecret);
    final spotify = SpotifyApi(credentials);
    return MusicDataSource(spotify, instance: instance);
  }

  /// Get a track from Spotify by its id
  /// It may throw a [SpotifyException] if the track is not found
  Future<Track> getTrack(String id) async {
    final track = await _spotifyApi.tracks.get(id);
    return track;
  }

  /// Search for a track by its name, returning the first result
  /// It may return null if no track is found
  Future<Track?> searchTrack(String query) async {
    final queryResult =
        _spotifyApi.search.get(query, types: [SearchType.track]);
    final page = (await queryResult.first()).first;
    final tracks = page.items?.first;
    return tracks as Track?;
  }

  /// Search for tracks by their name
  /// It may return null if no track is found. If [limit] is provided,
  /// it will return a list of tracks with at most the specified number of tracks
  Future<List<Track>?> searchTracks(String query, {int? limit}) async {
    final queryResult =
        _spotifyApi.search.get(query, types: [SearchType.track]);
    final page = (await queryResult.first()).first;
    final tracks = page.items?.toList();
    if (limit != null) return tracks?.take(limit).toList().cast();
    return tracks?.cast();
  }

  /// Save a [track] metadata to Firestore
  Future<void> saveTrackMetadata(Track track) async {
    final TrackMetadata trackMetadata = TrackMetadata.fromTrack(track);
    await _instance
        .collection('tracks')
        .doc(trackMetadata.id)
        .set(trackMetadata.toJson());
  }

  /// Get a [track] metadata from Firestore
  /// It may throw an exception if the track is not found
  Future<void> markTrackAsPlayed(String id) async {
    await _instance.collection('tracks').doc(id).update({'played': true});
  }

  /// Set the voter of a [track] metadata from Firestore
  /// It may throw an exception if the track is not found
  Future<void> voteTrack(String id, String userId) async {
    await _instance.collection('tracks').doc(id).update({
      'voters': FieldValue.arrayUnion([userId])
    });
  }

  /// Remove the voter of a [track] metadata from Firestore
  /// It may throw an exception if the track is not found
  Future<void> unvoteTrack(String id, String userId) async {
    await _instance.collection('tracks').doc(id).update({
      'voters': FieldValue.arrayRemove([userId])
    });
  }

  /// Get a list of [track] metadata from Firestore
  /// It may throw an exception if the track is not found
  Future<TrackMetadata> getTrackMetadata(String id) async {
    final tracks = await _instance.collection('tracks').doc(id).get();
    return TrackMetadata.fromJson(tracks.data()!);
  }
}
