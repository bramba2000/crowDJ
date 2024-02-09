import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:spotify/spotify.dart';

import '../../../core/env/env.dart';

/// A service to interact with the Spotify API
///
/// It provides methods to search for tracks and get track information
/// from the Spotify API. This class can interact only with the Spotify API that
/// does not require user authentication. To interact with the Spotify player,
/// or to get user-specific data, use [SpotifyUserService]
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
  /// It will propt the user a new wev view to authorize the app to access at
  /// his spotify account. If the user is already logged in, it will an instance
  /// of [SpotifyUserService] with the user's credentials
  Future<SpotifyUserService> createUserService() async {
    final scopes = [
      //...AuthorizationScope.user.all,
      ...AuthorizationScope.connect.all,
      ...AuthorizationScope.listen.all,
      ...AuthorizationScope.playlist.all,
    ];
    final credentials = await _spotifyApi.getCredentials();
    final grant = SpotifyApi.authorizationCodeGrant(credentials);
    final url = grant.getAuthorizationUrl(
      kIsWeb
          ? Uri.parse('${Env.host}/auth.html')
          : Uri.parse("crowdj://spotify-callback"),
      scopes: scopes,
    );
    final responseUri = await FlutterWebAuth2.authenticate(
        url: url.toString(), callbackUrlScheme: kIsWeb ? "http" : "crowdj");
    return SpotifyUserService(SpotifyApi.fromAuthCodeGrant(grant, responseUri));
  }
}

/// A service to interact with the Spotify player
///
/// It provides methods to interact with the Spotify API with user-specific
/// access to the Spotify player.
///
/// The first time on the app, the user must authorize the app to access his
/// Spotify account. To do so, use [createUserService] to create a new instance
/// of [SpotifyUserService].
///
/// After the user has authorized the app, the credentials will be saved. Use
/// [fromSavedCredentials] to create a new instance of [SpotifyUserService] from
/// the saved credentials; use [hasSavedCredentials] to check if there are saved.
class SpotifyUserService extends SpotifyService {
  static const String _credentialKey = 'spotify_credentials';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Create a new instance of [SpotifyUserService] providing a [SpotifyApi]
  /// instance
  const SpotifyUserService(super._spotifyApi);

  static Map<String, String> _credentialToJson(
          SpotifyApiCredentials credentials) =>
      {
        'clientId': credentials.clientId!,
        'clientSecret': credentials.clientSecret!,
        'accessToken': credentials.accessToken!,
        'refreshToken': credentials.refreshToken!,
        'tokenEndpoint': credentials.tokenEndpoint!.toString(),
        'scopes': credentials.scopes!.join(','),
        'expiration': credentials.expiration!.toIso8601String(),
      };

  static SpotifyApiCredentials _credentialFromJson(Map<String, String> json) =>
      SpotifyApiCredentials(
        json['clientId'],
        json['clientSecret'],
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        scopes: json['scopes']?.split(','),
        expiration: DateTime.parse(json['expiration']!),
      );

  /// Try to create a new instance of [SpotifyUserService] from saved
  /// credentials. It may return null if no credentials are found
  ///
  /// Consider using [hasSavedCredentials] to check if there are saved
  /// credentials before calling this method
  ///
  /// If the credentials are not found, consider using
  /// [SpotifyService.createUserService] to create a new instance of
  /// [SpotifyUserService]
  static Future<SpotifyUserService?> fromSavedCredentials() async {
    final json = await _storage.read(key: _credentialKey);
    if (json == null) return null;
    final credentials = _credentialFromJson(jsonDecode(json));
    final spotifyPlayerService = SpotifyUserService(SpotifyApi(credentials));
    await spotifyPlayerService._saveCredentials();
    return spotifyPlayerService;
  }

  /// Check if there are saved credentials for the Spotify user
  static Future<bool> get hasSavedCredentials async {
    return await _storage.containsKey(key: _credentialKey);
  }

  Future<void> _saveCredentials() async {
    final credentials = _credentialToJson(await _spotifyApi.getCredentials());
    await _storage.write(key: _credentialKey, value: jsonEncode(credentials));
  }

  /// Get the current playing track
  Future<PlaybackState> getCurrentPlaying() {
    return _spotifyApi.player.currentlyPlaying();
  }

  /// Pause the current playing track
  Future<PlaybackState?> pause() => _spotifyApi.player.pause();

  /// Start or resume the current playing track
  Future<PlaybackState?> resume() => _spotifyApi.player.resume();

  /// Skip to the next track
  Future<PlaybackState?> skipToNext() => _spotifyApi.player.next();

  /// Skip to the previous track
  Future<PlaybackState?> skipToPrevious() => _spotifyApi.player.previous();

  /// Load the tracks into the queue and start playing
  Future<void> addToQueue(List<String> trackIds) async {
    for (var trackId in trackIds) {
      await _spotifyApi.player.addToQueue(trackId);
    }
  }

  /// Check if a playlist with the given name exists for an event
  Future<PlaylistSimple?> searchPlaylistByEvent(
      {required String eventId}) async {
    final userId = (await _spotifyApi.me.get()).id;
    final searchResult = _spotifyApi.users.playlists(userId!);
    try {
      return (await searchResult.first()).items?.firstWhere(
          (element) => element.description?.contains(eventId) ?? false);
    } catch (e) {
      return null;
    }
  }

  /// Create a playlist with the given name and tracks ids
  Future<Playlist> createPlaylist(
      {required String name,
      required List<String> trackIds,
      required String eventId}) async {
    final userId = (await _spotifyApi.me.get()).id;
    final playlist = await _spotifyApi.playlists.createPlaylist(
        userId!, "$name - CrowDJ event",
        public: true,
        collaborative: false,
        description: 'Playlist created by CrowdJ for event $name ($eventId)');
    await _spotifyApi.playlists.addTracks(
        trackIds.map((e) => "spotify:track:$e").toList(), playlist.id!);
    return playlist;
  }

  Future<PlaybackState> reproducePlaylist(String playlistUri) async =>
      (await _spotifyApi.player
          .startWithContext(playlistUri, offset: PositionOffset(0)))!;
}
