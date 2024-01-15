import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify/spotify.dart';
import '../models/event_model.dart';
import '../models/track_metadata.dart';

/// Data source class for music related operations
/// This class is responsible for:
/// - adding tracks to an event
/// - getting tracks from an event
/// - voting tracks
class MusicDataSource {
  final FirebaseFirestore _instance;

  /// Create a new instance of [MusicDataSource] providing a [SpotifyApi] instance
  /// and optionally a [FirebaseFirestore] instance
  /// If no [FirebaseFirestore] instance is provided, the default one will be used
  MusicDataSource({FirebaseFirestore? firestore})
      : _instance = firestore ?? FirebaseFirestore.instance;

  /// Save a [track] metadata in event with [eventId] to Firestore
  Future<void> saveTrackMetadata(String eventId, Track track) async {
    final TrackMetadata trackMetadata = TrackMetadata.fromTrack(track);
    await _instance
        .collection(Event.collectionName)
        .doc(eventId)
        .collection(TrackMetadata.collectionName)
        .doc(trackMetadata.id)
        .set(trackMetadata.toJson());
  }

  /// Get a [trackId] metadata from Firestore
  /// It may throw an exception if the track is not found
  Future<void> markTrackAsPlayed(String eventId, String trackId) async {
    await _instance
        .collection(Event.collectionName)
        .doc(eventId)
        .collection(TrackMetadata.collectionName)
        .doc(trackId)
        .update({'played': true});
  }

  /// Set the voter of a [trackId] metadata from Firestore
  /// It may throw an exception if the track is not found
  Future<void> voteTrack(String eventId, String trackId, String userId) async {
    await _instance
        .collection(Event.collectionName)
        .doc(eventId)
        .collection(TrackMetadata.collectionName)
        .doc(trackId)
        .update({
      'voters': FieldValue.arrayUnion([userId])
    });
  }

  /// Remove the voter of a [trackId] metadata from Firestore
  /// It may throw an exception if the track is not found
  Future<void> unvoteTrack(
      String eventId, String trackId, String userId) async {
    await _instance
        .collection(Event.collectionName)
        .doc(eventId)
        .collection(TrackMetadata.collectionName)
        .doc(trackId)
        .update({
      'voters': FieldValue.arrayRemove([userId])
    });
  }

  /// Get a list of tracks metadata for the event with [eventId] from Firestore
  /// It may throw an exception if the track or the event is not found
  Future<List<TrackMetadata>> getTracksMetadata(String eventId) async {
    final tracks = await _instance
        .collection(Event.collectionName)
        .doc(eventId)
        .collection(TrackMetadata.collectionName)
        .get();
    return tracks.docs.map((e) => TrackMetadata.fromJson(e.data())).toList();
  }
}
