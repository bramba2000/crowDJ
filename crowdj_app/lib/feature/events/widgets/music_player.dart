import 'package:flutter/material.dart';

import '../../auth/data/user_data_source.dart';
import '../../auth/models/user_props.dart';
import '../models/track_metadata.dart';
import '../services/event_service.dart';

class MusicPlayer extends StatefulWidget {
  final String eventId;
  final String userID;

  const MusicPlayer({super.key, required this.eventId, required this.userID});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late List<TrackMetadata> tracks;
  late Future<List<TrackMetadata>> tracksfuture;
  int currentTrackIdx = -1;
  bool isPlaying = false;

  final EventService _eventService = EventService();
  late UserProps user;

  _loadUserProps(String userID) async {
    UserDataSource userDataSource = UserDataSource();
    user = await userDataSource.getUserProps(userID);
  }

  _loadtracks(String eventId) async {
    tracksfuture = _eventService.getTracksMetadata(eventId);
    tracks = await tracksfuture;
    currentTrackIdx =
        tracks.isNotEmpty && currentTrackIdx == -1 ? 0 : currentTrackIdx;
  }

  @override
  void initState() {
    super.initState();
    _loadUserProps(widget.userID);
    _loadtracks(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: tracksfuture,
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
        Text(tracks[currentTrackIdx].name),
        _player(),
      ],
    );
  }

  Widget _albumImage() {
    return Image.network(
      tracks[currentTrackIdx].imageUrl,
      //width: 300,
      //height: 300,
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
          onPressed: () {
            setState(() {
              currentTrackIdx = currentTrackIdx == 0
                  ? tracks.length - 1
                  : currentTrackIdx - 1;
            });
          },
        ),

        // Play/Pause button
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: () {
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
          onPressed: () {
            setState(() {
              currentTrackIdx = currentTrackIdx == tracks.length - 1
                  ? 0
                  : currentTrackIdx + 1;
            });
          },
        ),
      ],
    );
  }
}
