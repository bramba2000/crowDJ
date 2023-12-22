import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/Song.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../events/data/events_data_source.dart';
import '../../../events/models/event_model.dart';
import '../../../mapHandler/DynMap.dart';
import '../../../mapHandler/MapModel.dart';
import '../../data/auth_data_source.dart';
import '../../data/user_data_source.dart';
import '../../models/user_props.dart';
import '../../providers/authentication_provider.dart';
import '../../providers/state/authentication_state.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ///---->user details<----
  ///
  final provider = authNotifierProvider(AuthDataSource(), UserDataSource());
  late UserProps userProps;
  late String _userID;

  ///---->map<----
  ///
  final MapController _mapController = MapController();
  late MapModel _mapModel;
  late DynMap _map;

  ///----> events <----
  ///
  late EventDataSource _eventDataSource;
  late List<Event> _events = [];

  Future<void> _loadEvents() async {
    _eventDataSource = EventDataSource();
    /*
    List<Event> events = [
      Event(
          eventID: 1,
          title: "festa della salamella",
          maxPeople: 200,
          genere: "folk",
          songs: [
            Song(songID: 11, artist: "Bello figo", title: "pasta con tonno"),
            Song(songID: 12, artist: "Rovere", title: "affogare")
          ]),
      Event(
          eventID: 2,
          title: "boom festival",
          maxPeople: 15000,
          genere: "techno",
          songs: [
            Song(songID: 21, artist: "k", title: "psy and fly"),
            Song(songID: 22, artist: "matrix", title: "drop it"),
            Song(songID: 23, title: "Heute Nacht", artist: "Maddix"),
            Song(songID: 24, title: "Organism Like Us", artist: "Sensorythm"),
          ])
    ];
    */

    try {
      _events = await _eventDataSource.getEventsOfUser(_userID);
      print("----events getted");
    } on Exception catch (e) {
      
      print("exception!!!!!!!!!!!!"+e.toString());
    }
    print("---events loaded");
  }

  void _getUserProps() {
    var watch = ref.watch(provider);
    if (watch is AuthenticationStateAuthenticated) {
      userProps = watch.userProps;
      _userID = watch.user.uid;
      print("---user props loaded");
      _loadEvents();
      
    } else {
      throw ErrorDescription(" impossible to load user props ");
    }

    setState(() {print("events:"+_events.toString());});

  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    try {
      _getUserProps();
      //_loadEvents();
    } catch (e) {
      return Scaffold(
        body: Center(
          child: Text("OPSSSS...."+e.toString()),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600 /* && usertype==DJ*/) {
          return _desktopDjPage();
        } else {
          return _mobileUserPage(screenWidth, screenHeight);
        }
      },
    );

    //_mobileUserPage(screenWidth, screenHeight)
  }

  Scaffold _desktopDjPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DJ HomePage"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          color: const Color.fromARGB(200, 19, 102, 170),
          child: Column(
            children: [
              Text(
                  "welcome ${userProps.name} ${userProps.surname} - ${userProps.userType}"),
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.go("/newEvent");
                        print("-> createNewEventPage");
                      },
                      child: const Text("create new event"),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "TITLE",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "SONGS",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "PALCE",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _events.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      color: const Color.fromARGB(199, 64, 150, 221),
                      height: 200,
                      child: _djEventRow(_events[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _djEventRow(Event e) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    e.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "max people: ${e.maxPeople}",
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.go("/event", extra: e);
                        },
                        child: const Text("manage the event"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          //height: 150,
          child: Column(
            children: [
              const Expanded(
                flex: 1,
                child: Text(
                  "Songs",
                  style: TextStyle(),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: const Color.fromARGB(198, 97, 165, 221),
                  child: const SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        ///TODO: add here songs' of event e
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          flex: 1,
          child: SizedBox(
            child: Center(child: Text("put the map here")),
          ),
        )
      ],
    );
  }

  Scaffold _mobileUserPage(double screenWidth, double screenHeight) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            yourEvents(),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "NEARBY EVENTS",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            _userMap(screenWidth, screenHeight),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "YOUR INVITATIONS",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            invitationsList(),
          ],
        ),
      ),
    );
  }

  Widget yourEvents() {
    return Column(children: [
      const Text(
        "YOUR EVENTS",
        style: TextStyle(
          fontSize: 20,
          color: Colors.blueGrey,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      eventList(),
    ]);
  }

  Widget eventList() {
    return Column(
      children: [
        for (var event in _events)
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  context.go("/homePage/EventPage", extra: event);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12.0), // Set border radius to 0 for a square button
                  ),
                  backgroundColor: const Color.fromARGB(255, 60, 158, 238),
                ),
                child: Text(
                  event.title,
                  style: const TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
            ],
          ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget elevatedBox(Event e, Color color) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(children: [
          Text(
            e.title,
            style: const TextStyle(
              color: Color.fromARGB(255, 47, 35, 150),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Text(
            "${e.maxPeople}",
            style: const TextStyle(
              color: Color.fromARGB(255, 47, 35, 150),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
      const SizedBox(height: 10),
    ]);
  }

  Widget _userMap(screenWidth, screenHeight) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color.fromARGB(255, 60, 158, 238),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: FutureBuilder<void>(
        future: _buildMap(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Container(
                height: 100,
                width: 100,
                child: const Text("error occurs while loading the map"),
              );
            } else {
              print("----------------- no snapshot errors, returning the map");
              return Container(
                  padding: EdgeInsets.all(8),
                  height: 300,
                  width: 100,
                  child: _map);
            }
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return Container(
                height: 100,
                width: 100,
                child: Text(
                    "----------------- error:" + snapshot.error.toString()),
              );
            } else {
              return const Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    semanticsLabel: "Loading ... ",
                  ),
                ),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<void> _buildMap() async {
    try {
      _mapModel = await MapModel.create(); //createEventsMap()
      _map = DynMap(
        mapModel: _mapModel,
        center: _mapModel.getCenter(),
        mapController: _mapController,
      );
      print("Map has been built");
      //return _map;
    } catch (e) {
      print(e.toString());
      //return _map;
    }
  }

  Widget invitationsList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          _events.length,
          (index) => Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            color: Colors.blue,
            child: Row(
              children: [
                elevatedBox(
                    _events[index], const Color.fromARGB(255, 99, 136, 235)),
                const SizedBox(width: 10.0),
                ElevatedButton(
                    onPressed: () => print("accettato"),
                    child: const Text("accept")),
                const SizedBox(width: 10.0),
                ElevatedButton(
                    onPressed: () => print("declinato"),
                    child: const Text("decline")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
