import 'package:go_router/go_router.dart';

import '../../../../utils/Song.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../events/data/events_data_source.dart';
import '../../../events/models/event_model.dart';

class EventPage extends StatefulWidget {
  final Event arg;

  const EventPage({Key? key, required this.arg}) : super(key: key);

  @override
  // _EventPageState createState() => _EventPageState();
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool _showEventEditor = false;

  late List<Song> _songs;

  Future<void> _loadSongs() async {
    _songs = [
      Song(songID: 1, title: "titolo1", artist: "artist1"),
      Song(songID: 2, title: "titolo2", artist: "artist2"),
      Song(songID: 3, title: "titolo3", artist: "artist3"),
    ];
    Future.delayed(const Duration(seconds: 10));
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
                  print(
                      "----------------- no snapshot errors, returning the map");
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
                      "----------------- error:" + snapshot.error.toString(),
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
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.arg.title),
              ],
            ),
          ),
          Expanded(flex: 1, child: Text("max people: ${widget.arg.maxPeople}")),
          Expanded(
            child: Column(
              children: [
                for (Song s in _songs)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(s.title),
                      Text(s.artist),
                      Text("${s.songID}")
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopDjPage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      widget.arg.title,
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          fontFamily: AutofillHints.nickname),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "max people: ${widget.arg.maxPeople}",
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 6,
                    child: _songListContainer(),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  if (widget.arg.status == EventStatus.upcoming)
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: ElevatedButton(
                        child: _showEventEditor
                            ? const Text("undo")
                            : const Text("edit"),
                        onPressed: () {
                          setState(() {
                            _showEventEditor = !_showEventEditor;
                          });
                        },
                      ),
                    ),
                  if (_showEventEditor &&
                      widget.arg.status == EventStatus.upcoming)
                    Flexible(
                      flex: 4,
                      fit: FlexFit.loose,
                      child: ListView(
                        children: [
                          eventEditorForm(widget.arg),
                        ],
                      ),
                    ),
                  const Spacer(
                    flex: 1,
                  ),
                  if (widget.arg.status == EventStatus.past)
                    const Flexible(
                      flex: 3,
                      fit: FlexFit.loose,
                      child: Text("details and stats about the event"),
                    )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: _showImage(),
                  ),
                  if (widget.arg.status == EventStatus.ongoing)
                    Expanded(
                      flex: 1,
                      child: _showPlayer(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _songListContainer() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(198, 97, 165, 221),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            for (Song s in _songs)
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(197, 43, 122, 187),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text("${s.artist} - ${s.title} "),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              )
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
          SizedBox(
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
          SizedBox(
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
                  context.go("/");
                },
                child: Text("apply changes"),
              ),
              ElevatedButton(
                onPressed: () {
                  _eventDataSource.deleteEvent(event.id);
                  context.go("/");
                },
                child: Text("delete event"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
