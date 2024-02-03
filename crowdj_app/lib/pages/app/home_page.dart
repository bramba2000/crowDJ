import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/utils/EventExtra.dart';
import '../../feature/events/data/events_data_source.dart';
import '../../feature/events/data/participant_data_source.dart';
import '../../feature/events/models/event_model.dart';
import '../../feature/events/services/event_service.dart';
import '../../feature/events/widgets/event_display.dart';
import '../../feature/mapHandler/DynMap.dart';
import '../../feature/mapHandler/MapModel.dart';
import '../../feature/auth/data/auth_data_source.dart';
import '../../feature/auth/data/user_data_source.dart';
import '../../feature/auth/models/user_props.dart';
import '../../feature/auth/providers/authentication_provider.dart';
import '../../feature/auth/providers/state/authentication_state.dart';
import '../../feature/mapHandler/UserMap.dart';
import 'utils/appBar.dart';

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

  ///----> events <----
  ///
  final EventDataSource _eventDataSource = EventDataSource();
  late final Future<List<Event?>> _myEventsFuture;
  late List<Event?> _myEvents;

  Future<List<Event?>> _loadMyEvents() async {
    List<Event?> eventList = [];
    if (_userProps.userType == UserType.dj) {
      eventList = await EventService().getEventsByCreator(_userID);
    } else {
      List<String> myEventsIDs =
          await ParticipantDataSource().getRegisteredEvents(_userID);
      for (String id in myEventsIDs) {
        eventList.add(await _eventDataSource.getEvent(id));
      }
    }

    _myEvents = eventList;
    return eventList;
  }

  void _getUserProps() {
    var watch = ref.read(provider);
    if (watch is AuthenticationStateAuthenticated) {
      _userProps = watch.userProps;
      _userID = watch.user.uid;
      //print("---user props loaded");
    } else {
      throw ErrorDescription(" impossible to load user props ");
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserProps();
    _myEventsFuture = _loadMyEvents();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    return LayoutBuilder(
      builder: (context, constraints) {
        return FutureBuilder<List<Event?>>(
          future: _myEventsFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<Event?>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const SizedBox(
                  height: 100,
                  width: 100,
                  child: Text("error occurs while loading the info"),
                );
              } else {
                if (_userProps.userType == UserType.dj) {
                  return _desktopDjPage();
                } else {
                  return _mobileUserPage();
                }
              }
            }
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasError) {
                return SizedBox(
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
    );

    //_mobileUserPage(screenWidth, screenHeight)
  }

  Scaffold _desktopDjPage() {
    return Scaffold(
      appBar: CustomAppBar(text: "DJ Homepage"),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
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
                //margin: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          "TITLE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          "PLACE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _myEvents.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      //color: const Color.fromARGB(199, 64, 150, 221),
                      child: _djEventWrap(_myEvents[index]!),
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

  Widget _djEventWrap(Event e) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.horizontal,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EventDisplay(event: e),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.go("/event/${e.id}",
                            extra: EventExtra(event: e, sub: true));
                      },
                      child: const Text("manage the event"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 200),
          child: _djMap(e),
        )
      ],
    );
  }

  Scaffold _mobileUserPage() {
    return Scaffold(
      appBar: CustomAppBar(
        text: "Homepage",
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                //color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            UserMap(
              myEvents: _myEvents,
              eventDataSource: _eventDataSource,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget yourEvents() {
    return Column(children: [
      Text(
        "MY EVENTS",
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).colorScheme.onBackground,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      _myEvents.isEmpty
          ? const Text("you didn't subscribe to any event")
          : eventList(),
    ]);
  }

  Widget eventList() {
    //print(_myEvents.toString());
    return Column(
      children: [
        for (Event? event in _myEvents)
          Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.go("/event/{${event.id}}",
                        extra: EventExtra(event: event, sub: true));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12.0), // Set border radius to 0 for a square button
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Text(
                    event!.title,
                    style: TextStyle(
                        fontSize: 20.0,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ),
              ],
            ),
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
              //color: Color.fromARGB(255, 47, 35, 150),
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
              //color: Color.fromARGB(255, 47, 35, 150),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
      const SizedBox(height: 10),
    ]);
  }

  Widget _djMap(Event e) {
    return Container(
      child: FutureBuilder<DynMap>(
        future: _builDJMap(GeoPoint(e.location.latitude, e.location.longitude)),
        builder: (BuildContext context, AsyncSnapshot<DynMap> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return SizedBox(
                height: 100,
                width: 100,
                child: Text(
                    "error occurs while loading the map ${snapshot.error.toString()}"),
              );
            } else {
              return Container(child: snapshot.data);
            }
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return SizedBox(
                height: 100,
                width: 100,
                child: Text(
                    "----------------- error: ${snapshot.error.toString()} "),
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
      MapModel model = MapModel(g: eventLocation);
      model.updatePlace(eventLocation);
      return DynMap(
        mapModel: model,
        center: model.getCenter(),
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
}
