import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/spotify.dart' as spotify;

import '../../../pages/app/utils/appBar.dart';
import '../../auth/data/auth_data_source.dart';
import '../../auth/data/user_data_source.dart';
import '../../auth/models/user_props.dart';
import '../../auth/providers/authentication_provider.dart';
import '../../auth/providers/state/authentication_state.dart';
import '../data/participant_data_source.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/events_data_source.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';
import '../services/spotify_service.dart';
import '../widgets/event_display.dart';
import '../widgets/event_form.dart';
import '../widgets/join_event_form.dart';
import '../widgets/music_player.dart';
import '../widgets/tracks_container.dart';

class EventPage extends ConsumerStatefulWidget {
  final String eventId;
  final Event? event;
  final bool isParticipant; // true if the user is already subscribed
  const EventPage({
    super.key,
    required this.eventId,
    this.event,
    this.isParticipant = false,
  });

  @override
  // _EventPageState createState() => _EventPageState();
  ConsumerState createState() => _EventPageState();
}

class _EventPageState extends ConsumerState<EventPage> {
  late final String? _userId;
  late final UserType _userType;
  bool _showEventEditor = false;
  final EventService _eventService = EventService();
  final SpotifyService _spotifyService = SpotifyService.fromEnvironment();
  late final Future<Event?> _event =
      widget.event != null ? Future.value(widget.event) : _loadEvent();

  List<spotify.Track>? _songsSearchRes;

  Future<Event?> _loadEvent() async =>
      widget.event ?? await _eventService.getEvent(widget.eventId);

  @override
  void initState() {
    super.initState();
    final provider = authNotifierProvider(AuthDataSource(), UserDataSource());
    final result = ref.read(provider.select(
      (state) => switch (state) {
        AuthenticationStateAuthenticated auth => (
            auth.user.uid,
            auth.userProps.userType
          ),
        _ => null,
      },
    ));
    if (result == null) {
      throw Exception("user not authenticated");
    } else {
      _userId = result.$1;
      _userType = result.$2;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                      )
                                    : EventDisplay(event: snapshot.data!),
                              ),
                              if (!widget.isParticipant)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: JoinEventForm(event: snapshot.data!),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: 400,
                          ),
                          child: musicPlayer(
                              eventId: widget.eventId, 
                              userID: _userId!),
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
                                userID: _userId!,
                              ),
                              if (snapshot.data!.status ==
                                  EventStatus.upcoming) ...[
                                _addSongContainer(snapshot.data!),
                              ],
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

  Padding _mobileUserPage(Event? event) {
    if (event == null) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text("error occurs while loading the info"),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        itemCount: 1,
        //scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TracksContainer(eventId: event.id, userID: _userId!),
              if (widget.isParticipant)
                _addSongContainer(event)
              else
                _registerToEvent(event),
            ],
          );
        },
      ),
    );
  }

  Widget _desktopDjPage(Event? event) {
    if (event == null) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text("error occurs while loading the info"),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Row(
        children: [
          Flexible(
            //fit: FlexFit.loose,
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      fontFamily: AutofillHints.nickname),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "max people: ${event.maxPeople}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                TracksContainer(eventId: event.id, userID: _userId!),
                const SizedBox(
                  height: 20,
                ),
                if (event.status == EventStatus.upcoming)
                  ElevatedButton(
                    child: _showEventEditor
                        ? const Text("undo")
                        : const Text("edit"),
                    onPressed: () {
                      setState(() {
                        _showEventEditor = !_showEventEditor;
                      });
                    },
                  ),
                if (_showEventEditor && event.status == EventStatus.upcoming)
                  eventEditorForm(event),
                const SizedBox(
                  height: 20,
                ),
                if (event.status == EventStatus.past)
                  const Text("details and stats about the event"),
              ],
            ),
          ),
          Flexible(
            //fit: FlexFit.loose,
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (event.status == EventStatus.ongoing)
                  Flexible(
                    //fit: FlexFit.loose,
                    flex: 4,
                    child: Column(
                      children: [
                        _showImage(),
                        _showPlayer(),
                      ],
                    ),
                  ),
                if (event.status == EventStatus.upcoming)
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 1,
                    child: _addSongContainer(event),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _showImage() {
    String img =
        'https://media.istockphoto.com/id/176676918/it/foto/giovane-distogliere-corvo-guardare-verso-il-basso-con-una-mosca-morta.jpg?s=612x612&w=0&k=20&c=j9mPFysI2heVqhhlL_kEffxur9ZcxfUogA9Rpz7K3eE=';

    return FutureBuilder<http.Response>(
      future: http.get(Uri.parse(img)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // Display the image using Image.network
          return Image.network(img);
        } else {
          // Display a loading indicator while the image is being fetched
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _showPlayer() {
    return const SizedBox(
      child: Text(
        "player",
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
                //flex: 3,
                child: SizedBox(
                  //width: MediaQuery.of(context).size.width * 0.5,
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
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Text(
                            s.name!,
                          ),
                          Text(
                            s.album!.artists.toString(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
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

  Widget _registerToEvent(Event event) {
    return ElevatedButton(
      onPressed: () async {
        ParticipantDataSource participantDataSource = ParticipantDataSource();
        participantDataSource.addParticipant(event.id, _userId!);
        context.replace("/");
      },
      child: const Text("subscribe"),
    );
  }
}
