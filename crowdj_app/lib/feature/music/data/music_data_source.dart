import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify/spotify.dart';
import '../model/track_metadata.dart';

class MusicDataSource {
  final SpotifyApi _spotifyApi;
  final FirebaseFirestore _instance;

  MusicDataSource(this._spotifyApi, {FirebaseFirestore? instance})
      : _instance = instance ?? FirebaseFirestore.instance;

  factory MusicDataSource.fromCredentials(
      String clientId, String clientSecret, FirebaseFirestore? instance) {
    final credentials = SpotifyApiCredentials(clientId, clientSecret);
    final spotify = SpotifyApi(credentials);
    return MusicDataSource(spotify, instance: instance);
  }

  Future<Track> getTrack(String id) async {
    final track = await _spotifyApi.tracks.get(id);
    return track;
  }

  Future<void> saveTrackMetadata(Track track) async {
    final TrackMetadata trackMetadata = TrackMetadata.fromTrack(track);
    await _instance
        .collection('tracks')
        .doc(trackMetadata.id)
        .set(trackMetadata.toJson());
  }

  Future<void> markTrackAsPlayed(String id) async {
    await _instance.collection('tracks').doc(id).update({'played': true});
  }

  Future<void> voteTrack(String id, String userId) async {
    await _instance.collection('tracks').doc(id).update({
      'voters': FieldValue.arrayUnion([userId])
    });
  }

  Future<void> unvoteTrack(String id, String userId) async {
    await _instance.collection('tracks').doc(id).update({
      'voters': FieldValue.arrayRemove([userId])
    });
  }

  Future<List<TrackMetadata>> getTracksMetadata() async {
    final tracks = await _instance.collection('tracks').get();
    final tracksMetadata = tracks.docs
        .map((track) => TrackMetadata.fromJson(track.data()))
        .toList();
    return tracksMetadata;
  }
}
