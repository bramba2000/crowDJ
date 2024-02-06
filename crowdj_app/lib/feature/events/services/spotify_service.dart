import 'package:flutter/foundation.dart';
import 'package:spotify/spotify.dart';

import '../../../core/env/env.dart';

class SpotifyService {
  final SpotifyApi _spotifyApi;

  /// Create a new instance of [SpotifyService] providing a [SpotifyApi] instance
  const SpotifyService(this._spotifyApi);

  /// Create a new instance of [SpotifyService] providing Spotify credentials
  ///
  /// See default constuctor for more details
  factory SpotifyService.fromCredentials(String clientId, String clientSecret) {
    final credentials = SpotifyApiCredentials(clientId, clientSecret);
    final spotify = SpotifyApi(credentials);
    return SpotifyService(spotify);
  }

  /// Create a new instance of [SpotifyService] extracting Spotify credentials
  /// from environment variables
  ///
  factory SpotifyService.fromEnvironment() {
    final clientId = Env.spotifyClientId;
    final clientSecret = Env.spotifyClientSecret;
    return SpotifyService.fromCredentials(clientId, clientSecret);
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

  /// Trigger the authorization flow to authorize a new user with spotify
  ///
  /// It will return the authorization url to redirect the user to
  Future<Uri> createAuthorizationUrl() async {
    final scopes = [
      AuthorizationScope.connect.readCurrentlyPlaying,
      AuthorizationScope.connect.readPlaybackState,
    ];
    final credentials = await _spotifyApi.getCredentials();
    final grant = SpotifyApi.authorizationCodeGrant(credentials);
    final url = grant.getAuthorizationUrl(
      kIsWeb
          ? Uri.parse('${Env.host}/auth.html')
          : Uri.parse("crowdj://spotify-callback"),
      scopes: scopes,
    );
    return url;
  }
}
