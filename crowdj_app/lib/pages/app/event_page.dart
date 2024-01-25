import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/spotify.dart' as spotify;

import '../../feature/auth/data/auth_data_source.dart';
import '../../feature/auth/data/user_data_source.dart';
import '../../feature/auth/models/user_props.dart';
import '../../feature/auth/providers/authentication_provider.dart';
import '../../feature/auth/providers/state/authentication_state.dart';
import '../../feature/events/data/participant_data_source.dart';
import '../../feature/events/models/track_metadata.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../feature/events/data/events_data_source.dart';
import '../../feature/events/models/event_model.dart';
import '../../feature/events/services/event_service.dart';
import '../../feature/events/services/spotify_service.dart';
import '../../feature/events/widgets/event_form.dart';
import '../../feature/events/widgets/tracks_container.dart';

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

  Future _initilizeWidget() async {
    final list = await Future.wait([
      //_loadSongs(),
      _loadEvent(),
    ]);
  }

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
      appBar: AppBar(
        title: const Text("EVENT PAGE"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return FutureBuilder(
            future: _event,
            builder: (BuildContext context, AsyncSnapshot<Event?> snapshot) =>
                switch ((snapshot.connectionState, snapshot.hasError)) {
              (_, true) => const SizedBox(
                  height: 100,
                  width: 100,
                  child: Text("error occurs while loading the stream"),
                ),
              (ConnectionState.done, false) => constraints.maxWidth > 1000
                  ? Row(
                      children: [
                        Flexible(
                            flex: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: EventForm(
                                    event: snapshot.data,
                                    canEdit: _userType == UserType.dj,
                                  ),
                                ),
                              ],
                            )),
                        Flexible(
                          //fit: FlexFit.loose,
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (snapshot.data!.status == EventStatus.ongoing)
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
                              if (snapshot.data!.status ==
                                  EventStatus.upcoming) ...[
                                _addSongContainer(snapshot.data!),
                                TracksContainer(
                                    eventId: widget.eventId, userID: _userId!)
                              ],
                            ],
                          ),
                        ),
                      ],
                    )
                  : _mobileUserPage(snapshot.data),
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
          );
        },
      ),
    );
  }

  Padding _mobileUserPage(Event? _event) {
    if (_event == null) {
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
                    _event.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TracksContainer(eventId: _event.id, userID: _userId!),
              if (widget.isParticipant)
                _addSongContainer(_event)
              else
                _registerToEvent(_event),
            ],
          );
        },
      ),
    );
  }

  Widget _desktopDjPage(Event? _event) {
    if (_event == null) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text("error occurs while loading the info"),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        child: Row(
          children: [
            Flexible(
              //fit: FlexFit.loose,
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _event.title,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        fontFamily: AutofillHints.nickname),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "max people: ${_event.maxPeople}",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TracksContainer(eventId: _event.id, userID: _userId!),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_event.status == EventStatus.upcoming)
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
                  if (_showEventEditor && _event.status == EventStatus.upcoming)
                    eventEditorForm(_event),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_event.status == EventStatus.past)
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
                  if (_event.status == EventStatus.ongoing)
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
                  if (_event.status == EventStatus.upcoming)
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: _addSongContainer(_event),
                    ),
                ],
              ),
            ),
          ],
        ),
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
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _showPlayer() {
    return SizedBox(
      child: Text(
        "player",
      ),
    );
  }

  Widget eventEditorForm(Event event) {
    TextEditingController _titleController = TextEditingController();
    _titleController.text = event.title;
    TextEditingController _descriptionController = TextEditingController();
    _descriptionController.text = event.description;
    String _selectedGenre = event.genre;

    EventDataSource _eventDataSource = EventDataSource();

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
            controller: _titleController,
            decoration: InputDecoration(labelText: "title"),
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
            controller: _descriptionController,
            decoration: InputDecoration(labelText: "description of the event"),
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
            value: _selectedGenre,
            items: musicGenres.map((genre) {
              return DropdownMenuItem<String>(
                value: genre,
                child: Text(genre),
              );
            }).toList(),
            onChanged: (value) {
              _selectedGenre = value!;
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
                  _eventDataSource.updateEvent(
                      id: event.id,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      genre: _selectedGenre);
                  setState(() {});
                  context.replace("/");
                },
                child: const Text("apply changes"),
              ),
              ElevatedButton(
                onPressed: () {
                  _eventDataSource.deleteEvent(event.id);
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
    TextEditingController _songTitle = TextEditingController();

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
      _songTitle.text = "";
      //await _loadSongs();
    }

    return Container(
      padding: EdgeInsets.all(20),
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
                    controller: _songTitle,
                    decoration: const InputDecoration(labelText: 'Song Title'),
                    validator: (value) => null,
                  ),
                ),
              ),
              Flexible(
                child: ElevatedButton(
                    onPressed: () => updateSongs(_songTitle.text),
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
                          child: Text("add"),
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
    return Container(
      child: ElevatedButton(
        onPressed: () async {
          ParticipantDataSource participantDataSource = ParticipantDataSource();
          participantDataSource.addParticipant(event.id, _userId!);
          context.replace("/");
        },
        child: Text("subscribe"),
      ),
    );
  }
}
