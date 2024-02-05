import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/router/utils/EventExtra.dart';
import '../../feature/events/models/event_model.dart';
import '../../feature/events/services/event_service.dart';
import '../../feature/events/widgets/event_display.dart';
import '../../feature/auth/data/auth_data_source.dart';
import '../../feature/auth/data/user_data_source.dart';
import '../../feature/auth/models/user_props.dart';
import '../../feature/auth/providers/authentication_provider.dart';
import '../../feature/auth/providers/state/authentication_state.dart';
import '../../feature/mapHandler/providers/current_event.dart';
import '../../feature/mapHandler/providers/position.dart';
import '../../feature/mapHandler/widgets/user_map.dart';
import '../../feature/mapHandler/models/map_data.dart';
import '../../feature/mapHandler/widgets/dynamic_map.dart';
import 'utils/appBar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  //
  final EventService _eventService = EventService();

  final provider =
      authNotifierProvider(defaultAuthDataSource, defaultUserDataSource);
  late final UserProps _userProps = ref.read(provider.select((state) {
    if (state is AuthenticationStateAuthenticated) {
      return state.userProps;
    } else {
      throw ErrorDescription(" impossible to load user props ");
    }
  }));
  late final String _userID = ref.read(provider.select((state) {
    if (state is AuthenticationStateAuthenticated) {
      return state.user.uid;
    } else {
      throw ErrorDescription(" impossible to load user props ");
    }
  }));

  late final Future<List<Event?>> _myEventsFuture;

  // It is a list of events that the user is registered if [_userProps.userType]
  // is [UserType.user], otherwise it is a list of events created by the user
  // late List<Event?> _myEvents;

  /// Load the events of the user
  Future<List<Event?>> _loadMyEvents() async {
    late final List<Event?> eventList;
    if (_userProps.userType == UserType.dj) {
      eventList = await _eventService.getEventsByCreator(_userID);
    } else {
      eventList = await _eventService.getRegisteredEvents(_userID);
    }
    return eventList;
  }

  @override
  void initState() {
    super.initState();
    _myEventsFuture = _loadMyEvents();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    return Scaffold(
      appBar: CustomAppBar(
        text: "Home page",
      ),
      body: FutureBuilder(
          future: _myEventsFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<Event?>> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return switch ((snapshot.connectionState, snapshot.hasError)) {
              (_, true) => const SizedBox(
                  height: 100,
                  width: 100,
                  child: Text("error occurs while loading the info"),
                ),
              (ConnectionState.done || ConnectionState.active, false) =>
                (_userProps.userType == UserType.dj)
                    ? _desktopDjPage(snapshot.data!)
                    : _mobileUserPage(),
              (_, false) => const Center(
                  child: CircularProgressIndicator(),
                )
            };
          }),
    );
    /* return LayoutBuilder(
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
                  return _desktopDjPage(snapshot.data!);
                } else {
                  return _mobileUserPage(snapshot.data!);
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
    ); */

    //_mobileUserPage(screenWidth, screenHeight)
  }

  Widget _desktopDjPage(List<Event?> _myEvents) {
    return Padding(
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
    );
  }

  /// Return a wrap widget that contains the event details and the map of
  /// the event
  Widget _djEventWrap(Event e) {
    final double maxHeigth = max(MediaQuery.of(context).size.height * 0.4, 400);

    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.horizontal,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 500, maxHeight: maxHeigth),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
          constraints: BoxConstraints(maxWidth: 600, maxHeight: maxHeigth),
          child: DynamicMap(
            enableMovement: false,
            mapData: MapData.fromSingleEvent(e),
          ),
        )
      ],
    );
  }

  Widget _mobileUserPage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          const _MyEventsList(),
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
          Container(
              alignment: Alignment.center,
              constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
              child: FutureBuilder<LatLng>(
                  future: ref.read(currentPositionProvider.future),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text("error occurs while loading the map");
                      } else {
                        return UserMap(
                          initialPosition: snapshot.data!,
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
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
}

class _MyEventsList extends ConsumerWidget {
  const _MyEventsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Event?> _myEvents = ref.watch(currentEventsProvider);
    return Column(children: [
      const Text(
        "MY EVENTS",
        style: TextStyle(
          fontSize: 20,
          //color: Colors.blueGrey,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      _myEvents.isEmpty
          ? const Text("you didn't subscribe to any event")
          : _eventList(context, _myEvents),
    ]);
  }

  Widget _eventList(BuildContext context, List<Event?> myEvents) {
    //print(_myEvents.toString());
    return Column(
      children: [
        for (Event? event in myEvents)
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
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Text(
                    event!.title,
                    style: TextStyle(
                        fontSize: 20.0,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
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
}
