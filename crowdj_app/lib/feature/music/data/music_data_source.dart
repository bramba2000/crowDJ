import 'package:spotify/spotify.dart';

class MusicDataSource {
  final SpotifyApi _spotifyApi;

  MusicDataSource(this._spotifyApi);
  factory MusicDataSource.fromCredentials(
      String clientId, String clientSecret) {
    final credentials = SpotifyApiCredentials(clientId, clientSecret);
    final spotify = SpotifyApi(credentials);
    return MusicDataSource(spotify);
  }

  Future<Track> getTrack(String id) async {
    final track = await _spotifyApi.tracks.get(id);
    return track;
  }
}
