import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/spotify.dart' as spotify;

import '../../../pages/app/utils/appBar.dart';
import '../../auth/models/user_props.dart';

import 'package:flutter/material.dart';

import '../../auth/providers/utils_auth_provider.dart';
import '../../mapHandler/providers/current_event.dart';
import '../data/events_data_source.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';
import '../services/spotify_service.dart';
import '../widgets/event_display.dart';
import '../widgets/event_form.dart';
import '../widgets/join_event_form.dart';
// import '../widgets/music_player.dart';
import '../widgets/music_player.dart';
import '../widgets/tracks_container.dart';

class EventPage extends ConsumerStatefulWidget {
  final String eventId;
  final Event? event;
  final bool? isParticipant; // true if the user is already subscribed
  const EventPage({
    super.key,
    required this.eventId,
    this.event,
    this.isParticipant,
  });

  @override
  // _EventPageState createState() => _EventPageState();
  ConsumerState createState() => _EventPageState();
}

class _EventPageState extends ConsumerState<EventPage> {
  late final String _userId;
  late final UserType _userType;
  final EventService _eventService = EventService();
  final SpotifyService _spotifyService = SpotifyService.fromEnvironment();
  late final Future<Event?> _event;
  late final Future<bool> _isParticipantFuture;

  List<spotify.Track>? _songsSearchRes;

  Future<Event?> _loadEvent() async =>
      widget.event ?? await _eventService.getEvent(widget.eventId);

  Future<bool> _loadIsParticipant() async =>
      (await _eventService.getRegisteredEvents(_userId))
          .contains((await _event));

  @override
  void initState() {
    super.initState();
    _event = widget.event != null ? Future.value(widget.event) : _loadEvent();
    _userId = ref.read(userIdProvider)!;
    _userType = ref.read(userPropsProvider)!.userType;
    if (widget.isParticipant == null) {
      _isParticipantFuture = _loadIsParticipant();
    }
    _isParticipantFuture = widget.isParticipant != null
        ? Future.value(widget.isParticipant)
        : _loadIsParticipant();
  }

  @override
  Widget build(BuildContext context) {
    print(_userType);
    return Scaffold(
      appBar: CustomAppBar(
        text: "EVENT PAGE",
      ),
      body: FutureBuilder(
        future: _event,
        builder: (BuildContext context, AsyncSnapshot<Event?> snapshot) =>
            switch ((snapshot.connectionState, snapshot.hasError)) {
          (_, true) => const SizedBox(
              height: 100,
              width: 100,
              child: Text("error occurs while loading the stream"),
            ),
          (ConnectionState.done, false) => Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 40,
                      runSpacing: 10,
                      children: [
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: 400,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _userType == UserType.dj
                                    ? EventForm(
                                        event: snapshot.data!,
                                        canEdit: _userType == UserType.dj &&
                                            snapshot.data!.status !=
                                                EventStatus.past,
                                        onEventSubmitted: () {
                                          ref.invalidate(createdEventsProvider);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Event successfully updated'),
                                            ),
                                          );
                                        },
                                      )
                                    : EventDisplay(event: snapshot.data!),
                              ),
                              if (_userType == UserType.participant)
                                _joinEventForm(snapshot.data!),
                              if (_userType == UserType.dj &&
                                  snapshot.data! is PrivateEvent) ...[
                                const Text("This is a private event"),
                                Text(
                                    "Access code ${(snapshot.data! as PrivateEvent).password}")
                              ],
                            ],
                          ),
                        ),
                        if (_userType == UserType.dj)
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 400,
                            ),
                            child: MusicPlayerWidget(snapshot.data!),
                          ),
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: 400,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TracksContainer(
                                eventId: widget.eventId,
                                userID: _userId,
                              ),
                              if (snapshot.data!.status ==
                                      EventStatus.upcoming &&
                                  widget.isParticipant!) ...[
                                _addSongContainer(snapshot.data!),
                              ],
                              /* if (!widget.isParticipant)
                                const Text(
                                    " you can add songs only if subscribed ") */
                              FutureBuilder(
                                  future: _isParticipantFuture,
                                  builder: ((context, snapshot) => snapshot
                                                  .connectionState ==
                                              ConnectionState.done &&
                                          snapshot.data == false
                                      ? const Text(
                                          " you can add songs only if subscribed ")
                                      : const SizedBox())),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          (ConnectionState.active || ConnectionState.waiting, false) =>
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text(
                      "Wait a few seconds while we look for this amazing event"),
                ],
              ),
            ),
          (ConnectionState.none, false) => const SizedBox(
              height: 100,
              width: 100,
              child: Text("the state is null :/"),
            ),
        },
      ),
    );
  }

  Widget _joinEventForm(Event event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: _isParticipantFuture,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasError) {
                return const Text(
                    "error occurs while checking if the user is subscribed");
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data!) {
                  return const Text("you are already subscribed to this event");
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: JoinEventForm(event: event),
                  );
                }
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }

  Widget eventEditorForm(Event event) {
    TextEditingController titleController = TextEditingController();
    titleController.text = event.title;
    TextEditingController descriptionController = TextEditingController();
    descriptionController.text = event.description;
    String selectedGenre = event.genre;

    EventDataSource eventDataSource = EventDataSource();

    List<String> musicGenres = [
      'all genres',
      'Rock',
      'Pop',
      'Hip Hop',
      'Electronic',
      'Jazz',
      'Classical',
      'Country',
      'R&B',
      'Blues',
    ];

    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Column(
        children: [
          //title
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(labelText: "title"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),

          //description
          TextFormField(
            controller: descriptionController,
            decoration:
                const InputDecoration(labelText: "description of the event"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              if (value.toString().length > 1000) {
                return 'max 1000 characters';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),

          //genre
          DropdownButtonFormField<String>(
            value: selectedGenre,
            items: musicGenres.map((genre) {
              return DropdownMenuItem<String>(
                value: genre,
                child: Text(genre),
              );
            }).toList(),
            onChanged: (value) {
              selectedGenre = value!;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Choose a genre',
              labelText: 'Music Genre',
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  eventDataSource.updateEvent(
                      id: event.id,
                      title: titleController.text,
                      description: descriptionController.text,
                      genre: selectedGenre);
                  setState(() {});
                  context.replace("/");
                },
                child: const Text("apply changes"),
              ),
              ElevatedButton(
                onPressed: () {
                  eventDataSource.deleteEvent(event.id);
                  setState(() {});
                  context.replace("/");
                },
                child: const Text("delete event"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _addSongContainer(Event event) {
    TextEditingController songTitle = TextEditingController();

    void updateSongs(String value) async {
      List<spotify.Track>? updatedSongs =
          await _spotifyService.searchTracks(value, limit: 3);
      setState(() {
        if (updatedSongs == null) {
          _songsSearchRes = [];
        } else {
          _songsSearchRes = updatedSongs;
        }
      });
    }

    void addSongToEvent(spotify.Track song) async {
      await _eventService.addTrackToEvent(event.id, song);
      songTitle.text = "";
      //await _loadSongs();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      //sarchbar
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: SizedBox(
                  child: TextFormField(
                    controller: songTitle,
                    decoration: const InputDecoration(labelText: 'Song Title'),
                    validator: (value) => null,
                  ),
                ),
              ),
              Flexible(
                child: ElevatedButton(
                    onPressed: () => updateSongs(songTitle.text),
                    child: const Text("search")),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          if (_songsSearchRes != null && _songsSearchRes != [])
            for (spotify.Track s in _songsSearchRes!)
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Text(
                            s.name!,
                          ),
                          Text(
                            s.album!.artists!
                                .map((artist) => artist.name)
                                .join(', '),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              addSongToEvent(s);
                            });
                          },
                          child: const Text("add"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
