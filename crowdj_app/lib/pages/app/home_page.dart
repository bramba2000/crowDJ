import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/utils/EventExtra.dart';
import '../../feature/events/data/events_data_source.dart';
import '../../feature/events/data/participant_data_source.dart';
import '../../feature/events/models/event_model.dart';
import '../../feature/mapHandler/DynMap.dart';
import '../../feature/mapHandler/MapModel.dart';
import '../../feature/auth/data/auth_data_source.dart';
import '../../feature/auth/data/user_data_source.dart';
import '../../feature/auth/models/user_props.dart';
import '../../feature/auth/providers/authentication_provider.dart';
import '../../feature/auth/providers/state/authentication_state.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ///---->user details<----
  ///
  final provider = authNotifierProvider(AuthDataSource(), UserDataSource());
  late UserProps _userProps;
  late String _userID;

  ///---->map<----
  ///
  final MapController _mapController = MapController();
  late MapModel _mapModel;
  late DynMap _map;
  double _zoom = 17.0;

  ///----> events <----
  ///
  final EventDataSource _eventDataSource = EventDataSource();
  late List<Event> _nearEvents = [];
  late List<Event?> _myEvents = [];
  double _radius = 5;

  Future<void> _loadNearEvents() async {
    try {
      if (_userProps.userType == UserType.dj) {
        _myEvents = await _eventDataSource.getEventsOfUser(_userID);
        print("---------------------------------------dj _events updated:");
      } 

      await _eventDataSource
          .getEventsWithinRadius(await MapModel.getCurrentLocation(), _radius)
          .listen((list) {
        // Handle each list as it arrives
        _nearEvents = list;
        print("---------------------------------------user _events updated:" +
            _nearEvents.toString());
      });
      
    } on Exception catch (e) {
      print(" error!!!!!!!!!!! " + e.toString());
      _nearEvents = [];
    }
  }

  Future<void> _loadMyEvents() async {
    List<String> myEventsIDs;
    _myEvents=[];
    myEventsIDs = await ParticipantDataSource().getRegisteredEvents(_userID);

    for (String id in myEventsIDs){
      _myEvents.add(await _eventDataSource.getEvent(id));
    }

  }

  Future<void> _getUserProps() async {
    var watch = ref.watch(provider);
    if (watch is AuthenticationStateAuthenticated) {
      _userProps = watch.userProps;
      _userID = watch.user.uid;
      //print("---user props loaded");
    } else {
      throw ErrorDescription(" impossible to load user props ");
    }
  }

  _initilizeWidget() async {
    await _getUserProps();
    await _loadMyEvents();
    await _loadNearEvents();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(
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
                  return _mobileUserPage(screenWidth, screenHeight);
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
    );

    //_mobileUserPage(screenWidth, screenHeight)
  }

  Scaffold _desktopDjPage() {
    //print("user: " + _userProps.toString());
    //print("id: " + _userID);
    //print("_events: " + _events.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text("DJ HomePage"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(provider.notifier).signOut();
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          color: const Color.fromARGB(200, 19, 102, 170),
          child: Column(
            children: [
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
                      "PALCE",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _myEvents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      color: const Color.fromARGB(199, 64, 150, 221),
                      height: 200,
                      child: _djEventRow(_myEvents[index]!),
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
                  child: Text(
                    "genre: ${e.genre}",
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "${e.startTime.day}/${e.startTime.month}/${e.startTime.year}",
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.go("/event", extra: EventExtra(event: e, sub: true));
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
          child: SizedBox(
            height: 200,
            width: 200,
            child: _djMap(e),
          ),
        )
      ],
    );
  }

  Scaffold _mobileUserPage(double screenWidth, double screenHeight) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
        actions: [
          IconButton(
            onPressed: () async {          
              await ref.read(provider.notifier).signOut();
              context.go("/");    
            }, 
            icon: const Icon(Icons.logout))
        ],
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
            _zoomSlider(),
            _slider(),
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
        "MY EVENTS",
        style: TextStyle(
          fontSize: 20,
          color: Colors.blueGrey,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      _myEvents.isEmpty ? const Text("you didn't subscribe to any event") : eventList(),
    ]);
  }

  Widget eventList() {
    //print(_myEvents.toString());
    return Column(
      children: [
        for (Event? event in _myEvents)
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  context.go("/event", extra: EventExtra(event: event, sub: true) );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12.0), // Set border radius to 0 for a square button
                  ),
                  backgroundColor: const Color.fromARGB(255, 60, 158, 238),
                ),
                child: Text(
                  event!.title,
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
        future: _builUserMap(),
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

  Future<void> _builUserMap() async {
    try {
      _mapModel = await MapModel.createEventsMap(_nearEvents, _myEvents, context); //createEventsMap()
      _mapModel.addYourCurrentPlace(_mapModel.getCenter());
      _map = DynMap(
        mapModel: _mapModel,
        center: _mapModel.getCenter(),
        mapController: _mapController,
        zoom: _zoom,
      );
      //print("Map has been built");
      //return _map;
    } catch (e) {
      print(e.toString());
      //return _map;
    }
  }

  Widget _djMap(Event e) {
    return Container(
      child: FutureBuilder<DynMap>(
        future: _builDJMap(GeoPoint(e.location.latitude, e.location.longitude)),
        builder: (BuildContext context, AsyncSnapshot<DynMap> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print("error occurs while loading the map " +
                  snapshot.error.toString());
              return Container(
                height: 100,
                width: 100,
                child: Text("error occurs while loading the map" +
                    snapshot.error.toString()),
              );
            } else {
              print("----------------- no snapshot errors, returning the map");
              return Container(
                  padding: EdgeInsets.all(8),
                  height: 300,
                  width: 100,
                  child: snapshot.data);
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

  Future<DynMap> _builDJMap(GeoPoint eventLocation) async {
    try {
      MapModel _model = await MapModel(g: eventLocation);
      _model.updatePlace(eventLocation);
      return DynMap(
        mapModel: _model,
        center: _model.getCenter(),
        mapController: MapController(),
        zoom: 10,
      );
    } on Exception catch (e) {
      print(e.toString());
      //MapModel _model = await MapModel.create();
      throw Error();
      //return DynMap(mapModel: _model, center: _model.getCenter() , mapController: MapController());
    }
  }

  Widget invitationsList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          _nearEvents!.length,
          (index) => Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            color: Colors.blue,
            child: Row(
              children: [
                elevatedBox(
                    _nearEvents![index], const Color.fromARGB(255, 99, 136, 235)),
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

  Widget _slider() {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: _radius,
            min: 1,
            max: 400000,
            label: _radius.toString()+" km ",
            divisions: 400,
            onChanged: (value) {
              setState(() {
                _radius = value;
              });
            },
          ),
        ),
        Text("$_radius"),
      ],
    );
  }

  Widget _zoomSlider() {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: _zoom,
            min: 10,
            max: 30,
            label: _zoom.toString(),
            divisions: 40,
            onChanged: (value) {
              setState(() {
                _zoom=value;
                _mapController.move(LatLng(_mapModel.getCenter().latitude, _mapModel.getCenter().longitude), _zoom);
              });
            },
          ),
        ),
        Text("$_zoom"),
      ],
    );
  }
}
