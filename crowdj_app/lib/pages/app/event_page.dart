import 'package:go_router/go_router.dart';
import 'package:spotify/spotify.dart' as spotify;

import '../../core/env/env.dart';
import '../../feature/music/data/music_data_source.dart';
import '../../feature/music/model/track_metadata.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../feature/events/data/events_data_source.dart';
import '../../feature/events/models/event_model.dart';
import '../../feature/events/widgets/tracks_container.dart';

class EventPage extends StatefulWidget {
  final Event arg;

  const EventPage({Key? key, required this.arg}) : super(key: key);

  @override
  // _EventPageState createState() => _EventPageState();
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool _showEventEditor = false;

  late List<TrackMetadata> _songs;
  List<spotify.Track>? _songsSearchRes;

  Future<void> _loadSongs() async {
    MusicDataSource _musicDataSource = MusicDataSource.fromCredentials(
      Env.spotifyClientId,
      Env.spotifyClientSecret,
    );

    _songs = await _musicDataSource.getTracksMetadata(widget.arg.id);
  }

  _initilizeWidget() async {
    await _loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EVENT PAGE")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return FutureBuilder<void>(
            future: _initilizeWidget(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const SizedBox(
                    height: 100,
                    width: 100,
                    child: Text("error occurs while loading the info"),
                  );
                } else {
                  if (constraints.maxWidth > 600 /* && usertype==DJ*/) {
                    return _desktopDjPage();
                  } else {
                    return _mobileUserPage();
                  }
                }
              }
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasError) {
                  return Container(
                    height: 100,
                    width: 100,
                    child: Text(
                      "----------------- error: ${snapshot.error.toString()}",
                    ),
                  );
                } else {
                  return const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        Text("loading ..."),
                      ],
                    ),
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      ),
    );
  }

  Padding _mobileUserPage() {
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
                    widget.arg.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TracksContainer(eventId: widget.arg.id),
              _addSongContainer(widget.arg),
            ],
          );
        },
      ),
    );
  }

  Widget _desktopDjPage() {
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
                    widget.arg.title,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        fontFamily: AutofillHints.nickname),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "max people: ${widget.arg.maxPeople}",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TracksContainer(eventId: widget.arg.id),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.arg.status == EventStatus.upcoming)
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
                  if (_showEventEditor &&
                      widget.arg.status == EventStatus.upcoming)
                    eventEditorForm(widget.arg),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.arg.status == EventStatus.past)
                    Text("details and stats about the event"),
                ],
              ),
            ),
            Flexible(
              //fit: FlexFit.loose,
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.arg.status == EventStatus.ongoing)
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
                  if (widget.arg.status == EventStatus.upcoming)
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: _addSongContainer(widget.arg),
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
    MusicDataSource _musicDataSource = MusicDataSource.fromCredentials(
      Env.spotifyClientId,
      Env.spotifyClientSecret,
    );

    TextEditingController _songTitle = TextEditingController();

    void updateSongs(String value) async {
      List<spotify.Track>? updatedSongs =
          await _musicDataSource.searchTracks(value, limit: 3);
      setState(() {
        if (updatedSongs == null) {
          _songsSearchRes = [];
        } else {
          _songsSearchRes = updatedSongs;
        }
      });
    }

    void addSongToEvent(spotify.Track song) async {
      await _musicDataSource.saveTrackMetadata(event.id, song);
      _songTitle.text = "";
      await _loadSongs();
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
}
