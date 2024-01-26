import 'package:flutter/material.dart';
import '../../auth/data/user_data_source.dart';
import '../../auth/models/user_props.dart';
import '../models/track_metadata.dart';
import '../services/event_service.dart';

class TracksContainer extends StatefulWidget {
  final String eventId;
  final String userID;

  TracksContainer({super.key, required this.eventId, required this.userID});

  @override
  State<TracksContainer> createState() => _TracksContainerState();
}

class _TracksContainerState extends State<TracksContainer> {
  final EventService _eventService = EventService();
  late UserProps user;

  _loadUserProps() async {
    UserDataSource userDataSource = UserDataSource();
    user = await userDataSource.getUserProps(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    _loadUserProps();
    return songsListView();
  }

  Widget songsListView() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(198, 97, 165, 221),
        borderRadius: BorderRadius.circular(20.0),
      ),
      constraints: const BoxConstraints(
        minHeight: 70,
        minWidth: 100,
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child: FutureBuilder(
        future: _eventService.getTracksMetadata(widget.eventId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final tracks = snapshot.data as List<TrackMetadata>;
            return tracks.isEmpty
                ? const Center(
                    child: Text(
                        "no songs so far... be the first, subscribe and add one!"))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: tracks.length,
                    itemBuilder: (context, index) {
                      final track = tracks[index];
                      return Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(198, 97, 165, 221),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.horizontal,
                          onDismissed: (direction) {
                            if (user.userType == UserType.participant) {
                              if (direction == DismissDirection.startToEnd) {
                                _eventService.voteTrack(
                                    widget.eventId, track.id, widget.userID);
                              } else {
                                _eventService.unvoteTrack(
                                    widget.eventId, track.id, widget.userID);
                              }
                              setState(() {});
                            }
                            if (user.userType == UserType.dj) {
                              if (direction == DismissDirection.endToStart) {
                                //delete the track
                                setState(() {});
                              } else {
                                //play the track
                              }
                            }
                          },
                          background: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 44, 145, 77),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.centerLeft,
                            child: (user.userType == UserType.participant)
                                ? const Text("vote now!")
                                : const Text("delete"),
                          ),
                          secondaryBackground: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 44, 53, 143),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.centerRight,
                            child: (user.userType == UserType.participant)
                                ? const Text("unvote")
                                : const Text("reproduce"),
                          ),
                          child: ListTile(
                            title: Text(track.name),
                            subtitle: Text(track.artist),
                            leading: Image.network(track.imageUrl),
                            trailing: Text(
                              "${track.voters.length} likes",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    },
                  );
          } else if (snapshot.hasError) {
            return const Text('Unable to retrieve the tracks for this event');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
