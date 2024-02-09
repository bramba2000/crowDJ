import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart' show PlaybackState, PlaylistSimple, Track;

import '../models/event_model.dart';
import '../models/track_metadata.dart';
import '../services/event_service.dart';
import '../services/spotify_service.dart';

class MusicPlayerWidget extends ConsumerStatefulWidget {
  final Event event;
  const MusicPlayerWidget(this.event, {super.key});

  @override
  ConsumerState<MusicPlayerWidget> createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends ConsumerState<MusicPlayerWidget> {
  late Future<SpotifyUserService?> _userService;

  Future<SpotifyUserService?> _loadPlayerService() async {
    if (await SpotifyUserService.hasSavedCredentials) {
      return (await SpotifyUserService.fromSavedCredentials())!;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _userService = _loadPlayerService();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _userService,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError) {
            if (snapshot.hasData) {
              return MusicPlayer(
                  userService: snapshot.data!, event: widget.event);
            } else {
              return _spotifyLoginButton();
            }
          } else if (snapshot.hasError) {
            return const Text('Unable to retrieve the tracks for this event');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  ElevatedButton _spotifyLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        final spotifyService = SpotifyService.fromEnvironment();
        setState(() {
          _userService = spotifyService.createUserService();
        });
      },
      child: const Text('Login to Spotify'),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  final SpotifyUserService userService;
  final Event event;
  const MusicPlayer(
      {required this.userService, required this.event, super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late Future<PlaybackState> currentPlaybackStateFuture;
  late final List<TrackMetadata> tracks;
  // ignore: unused_field
  late Timer _timer;
  Track? currentTrack;
  bool isPlaying = false;

  final EventService _eventService = EventService();

  Future<PlaybackState> _loadCurrentPlaybackState() async {
    late final PlaybackState currentPlaying;
    tracks = await _eventService.getTracksMetadata(widget.event.id);
    final PlaylistSimple? playlist = await widget.userService
        .searchPlaylistByEvent(eventId: widget.event.id);
    if (playlist == null) {
      final playlist = await widget.userService.createPlaylist(
          name: widget.event.title,
          trackIds: tracks.map((e) => e.id).toList(),
          eventId: widget.event.id);
      currentPlaying =
          await widget.userService.reproducePlaylist(playlist.uri!);
    } else {
      currentPlaying =
          await widget.userService.reproducePlaylist(playlist.uri!);
    }
    currentTrack = (await widget.userService.getCurrentPlaying()).item;
    isPlaying = true;
    _timer = Timer.periodic(const Duration(seconds: 5), _timerCallback);
    return currentPlaying;
  }

  void _timerCallback(timer) async {
    final currentPlaying = await widget.userService.getCurrentPlaying();
    final newIsPlaying = currentPlaying.isPlaying ?? false;
    final newCurrentTrack = currentPlaying.item;
    if (currentTrack?.id != newCurrentTrack?.id || isPlaying != newIsPlaying) {
      setState(() {
        currentTrack = newCurrentTrack;
        isPlaying = newIsPlaying;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    currentPlaybackStateFuture = _loadCurrentPlaybackState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: currentPlaybackStateFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return player();
          } else if (snapshot.hasError) {
            return const Text('Unable to retrieve the tracks for this event');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget player() {
    return Column(
      children: [
        _albumImage(),
        const SizedBox(
          height: 20,
        ),
        Text(currentTrack!.name!),
        _player(),
      ],
    );
  }

  Widget _albumImage() {
    return currentTrack == null
        ? const Placeholder()
        : Image.network(
            currentTrack!.album!.images!.first.url!,
            width: 200,
            height: 200,
          );
  }

  Widget _player() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //skip previous track
        IconButton(
          icon: const Icon(
            Icons.skip_previous,
          ),
          onPressed: () async {
            final playbackstate = await widget.userService.skipToPrevious();
            setState(() {
              currentTrack = playbackstate?.item;
            });
          },
        ),

        // Play/Pause button
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: () async {
            if (isPlaying) {
              await widget.userService.pause();
            } else {
              await widget.userService.resume();
            }
            setState(() {
              isPlaying = !isPlaying;
            });
          },
        ),

        //skip next track
        IconButton(
          icon: const Icon(
            Icons.skip_next,
          ),
          onPressed: () async {
            final playbackState = await widget.userService.skipToNext();
            setState(() {
              currentTrack = playbackState?.item;
            });
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (currentTrack != null) _timer.cancel();
    super.dispose();
  }
}
