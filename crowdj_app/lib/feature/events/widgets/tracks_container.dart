import 'package:flutter/material.dart';

import '../models/track_metadata.dart';
import '../services/event_service.dart';

class TracksContainer extends StatelessWidget {
  final String eventId;
  final EventService _eventService = EventService();

  TracksContainer({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(198, 97, 165, 221),
        borderRadius: BorderRadius.circular(20.0),
      ),
      constraints: const BoxConstraints(
        minHeight: 70,
        minWidth: 100,
      ),
      child: FutureBuilder(
          future: _eventService.getTracksMetadata(eventId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final tracks = snapshot.data as List<TrackMetadata>;
              print("Incoming tracks");
              print(tracks);
              return ListView.builder(
                shrinkWrap: true,
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                  final track = tracks[index];
                  return ListTile(
                    title: Text(track.name),
                    subtitle: Text(track.artist),
                    leading: Image.network(track.imageUrl),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Text('Unable to retrieve the tracks for this event');
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
